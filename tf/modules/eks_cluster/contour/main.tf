resource "kubernetes_namespace" "contour" {
  metadata {
    name = "projectcontour"
  }
}

resource "helm_release" "contour" {
  name             = "contour"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "contour"
  namespace        = kubernetes_namespace.contour.metadata[0].name
  version          = "12.1.0"

  values = [
    <<-EOT
    envoy:
      service:
        type: ClusterIP  # Changed from NodePort
        externalTrafficPolicy: null  # Remove invalid policy
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 200m
          memory: 256Mi
    contour:
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 200m
          memory: 256Mi
    EOT
  ]

  timeout = 300
  wait    = true

  depends_on = [
    kubernetes_namespace.contour,
    var.mod_dependency
  ]
}