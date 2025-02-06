provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  }
}

# CREATE IAM ROLE & POLICY FOR EBS CSI DRIVER

# IAM POLICY FOR EBS CSI DRIVER
resource "aws_iam_policy" "ebs_csi_policy" {
  name        = "EBSCSIControllerPolicy"
  description = "IAM policy for AWS EBS CSI Driver"
  policy      = file("${path.module}/ebs-csi-policy.json")
}

# IAM ROLE FOR EBS CSI DRIVER

resource "aws_iam_role" "ebs_csi_role" {
  name = "EBSCSIControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_eks_cluster.eks.identity.0.oidc.0.issuer}:oidc-provider/${replace(data.aws_eks_cluster.eks.identity.0.oidc.0.issuer, "https://", "")}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.eks.identity.0.oidc.0.issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })
}

# ATTACH POLICY TO IAM ROLE
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ebs_csi_role.name
  policy_arn = aws_iam_policy.ebs_csi_policy.arn
}

# CREATE KUBERNETES SERVICE ACCOUNT

resource "kubernetes_service_account" "ebs_csi_service_account" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ebs_csi_role.arn
    }
  }
}

# DEPLOY AWS EBS CSI DRIVER VIA HELM

resource "helm_release" "aws_ebs_csi_driver" {
  depends_on = [
    kubernetes_service_account.ebs_csi_service_account
  ]

  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "ebs-csi-controller-sa"
  }
}
