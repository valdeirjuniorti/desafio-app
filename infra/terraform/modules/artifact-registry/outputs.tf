output "registry_id" {
  description = "ID do Artifact Registry"
  value       = google_artifact_registry_repository.registry.id
}

output "registry_name" {
  description = "Nome do Artifact Registry"
  value       = google_artifact_registry_repository.registry.name
}

output "registry_location" {
  description = "Localização do registry"
  value       = google_artifact_registry_repository.registry.location
}

output "registry_url" {
  description = "URL do registry para push/pull de imagens"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.registry.name}"
}

output "registry_repository_id" {
  description = "ID do repositório"
  value       = google_artifact_registry_repository.registry.repository_id
}

output "registry_format" {
  description = "Formato do repositório"
  value       = google_artifact_registry_repository.registry.format
}

