output "contour_namespace" {
  description = "The namespace where Contour is installed"
  value       = helm_release.contour.namespace
}

output "contour_release_name" {
  description = "The name of the Helm release for Contour"
  value       = helm_release.contour.name
}