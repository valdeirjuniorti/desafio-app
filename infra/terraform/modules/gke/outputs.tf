output "cluster_id" {
  description = "ID do cluster GKE"
  value       = google_container_cluster.cluster.id
}

output "cluster_name" {
  description = "Nome do cluster GKE"
  value       = google_container_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster GKE"
  value       = google_container_cluster.cluster.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Certificado CA do cluster"
  value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "Localização do cluster"
  value       = google_container_cluster.cluster.location
}

output "cluster_region" {
  description = "Região do cluster"
  value       = var.region
}

output "cluster_network" {
  description = "Nome da rede do cluster"
  value       = google_container_cluster.cluster.network
}

output "cluster_subnetwork" {
  description = "Nome da subnet do cluster"
  value       = google_container_cluster.cluster.subnetwork
}

