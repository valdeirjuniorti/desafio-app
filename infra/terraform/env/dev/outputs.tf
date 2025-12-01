output "vpc_name" {
  description = "Nome da VPC"
  value       = module.vpc.vpc_name
}

output "cluster_name" {
  description = "Nome do cluster GKE"
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster GKE"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "cloud_sql_instance_name" {
  description = "Nome da instância Cloud SQL"
  value       = module.cloud_sql.instance_name
}

output "cloud_sql_private_ip" {
  description = "IP privado do Cloud SQL"
  value       = module.cloud_sql.instance_private_ip_address
}

output "cloud_sql_connection_name" {
  description = "Nome de conexão do Cloud SQL (para Cloud SQL Proxy)"
  value       = module.cloud_sql.instance_connection_name
}

output "database_connection_string" {
  description = "String de conexão do banco de dados (privada)"
  value       = module.cloud_sql.connection_string
  sensitive   = true
}

output "cluster_service_account" {
  description = "Service account do cluster"
  value       = module.security.cluster_service_account_email
}

output "node_service_account" {
  description = "Service account dos nodes"
  value       = module.security.node_service_account_email
}

output "registry_url" {
  description = "URL do Artifact Registry"
  value       = module.artifact_registry.registry_url
}

output "registry_name" {
  description = "Nome do Artifact Registry"
  value       = module.artifact_registry.registry_name
}

