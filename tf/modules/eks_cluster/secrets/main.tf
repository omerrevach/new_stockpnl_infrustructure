provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    token                  = var.eks_cluster_token
    cluster_ca_certificate = base64decode(var.eks_cluster_ca)
  }
}

# IAM Policy for External Secrets Operator (ESO)
resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "ExternalSecretsAccessPolicy"
  description = "Allow ESO to read AWS Secrets Manager"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:*"
    }
  ]
}
EOF
}

# IAM Role for ESO (Using IRSA)
resource "aws_iam_role" "eso_role" {
  name = "ESO_IRSA_Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.account_id}:oidc-provider/${replace(var.oidc_provider_arn, "https://", "")}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(var.oidc_provider_arn, "https://", "")}:sub": "system:serviceaccount:external-secrets:external-secrets-sa",
          "${replace(var.oidc_provider_arn, "https://", "")}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}

# Attach IAM Policy to ESO Role
resource "aws_iam_role_policy_attachment" "attach_secrets_policy" {
  role       = aws_iam_role.eso_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

# Install External Secrets Operator using Helm
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-secrets-sa"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.eso_role.arn
  }
}