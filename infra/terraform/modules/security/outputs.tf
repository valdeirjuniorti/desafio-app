output "cluster_service_account_email" {
  description = "Email da service account do cluster"
  value       = google_service_account.cluster_sa.email
}

output "cluster_service_account_id" {
  description = "ID da service account do cluster"
  value       = google_service_account.cluster_sa.id
}

output "node_service_account_email" {
  description = "Email da service account dos nodes"
  value       = google_service_account.node_sa.email
}

output "node_service_account_id" {
  description = "ID da service account dos nodes"
  value       = google_service_account.node_sa.id
}

