output "contour_namespace" {
  value       = helm_release.contour.namespace
}

output "contour_release_name" {
  value       = helm_release.contour.name
}