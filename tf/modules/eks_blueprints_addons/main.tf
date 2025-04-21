module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "1.15.1"
  cluster_name = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  cluster_version = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn
  
  enable_argocd = true
  enable_aws_load_balancer_controller = true
  enable_external_secrets = true
  enable_external_dns = true
  
  # Route53 zone ARN configuration
  external_dns_route53_zone_arns = [
    "arn:aws:route53:::hostedzone/Z022564630P941WV72XMM"
  ]
  
  # Configure external-dns
  external_dns = {
    set = [
      {
        name = "policy"
        value = "sync"
      },
      {
        name = "domainFilters[0]"
        value = "stockpnl.com"
      },
      {
        name = "txtOwnerId"
        value = "stockpnl-eks"
      },
      {
        name = "sources[0]"
        value = "service"
      },
      {
        name = "sources[1]"
        value = "ingress"
      }
    ]
  }
  
  # Configure the AWS Load Balancer Controller
  aws_load_balancer_controller = {
    set = [
      {
        name = "vpcId"
        value = var.vpc_id
      }
    ]
  }
  
  # Configure External Secrets
  external_secrets = {
    set = [
      {
        name = "region"
        value = var.region
      }
    ]
  }
  
  # Configure ArgoCD with settings from the working example
  argocd = {
    namespace     = "argocd"
    chart_version = "5.51.6"
    repository    = "https://argoproj.github.io/argo-helm"
    values = [
      <<-EOF
      server:
        extraArgs:
          - --insecure

        service:
          type: ClusterIP
          servicePortHttp: 8080
          servicePortHttps: 8080

        ingress:
          enabled: true
          ingressClassName: alb
          annotations:
            alb.ingress.kubernetes.io/scheme: internet-facing
            alb.ingress.kubernetes.io/target-type: ip
            alb.ingress.kubernetes.io/group.name: argocd-group
            alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
            alb.ingress.kubernetes.io/backend-protocol: HTTP
            alb.ingress.kubernetes.io/healthcheck-path: /
            alb.ingress.kubernetes.io/success-codes: "200-399"
            alb.ingress.kubernetes.io/load-balancer-attributes: idle_timeout.timeout_seconds=120
            alb.ingress.kubernetes.io/ssl-redirect: '443'
            alb.ingress.kubernetes.io/certificate-arn: ${data.aws_acm_certificate.argocd.arn}
            external-dns.alpha.kubernetes.io/hostname: argocd.stockpnl.com
          hosts:
            - argocd.stockpnl.com
          path: /
          pathType: Prefix

      configs:
        cm:
          url: https://argocd.stockpnl.com
        params:
          server.insecure: "true"
      EOF
    ]
  }
}

