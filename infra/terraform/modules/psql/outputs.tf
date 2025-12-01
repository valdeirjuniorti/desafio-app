output "instance_name" {
  description = "Nome da instância Cloud SQL"
  value       = google_sql_database_instance.postgres.name
}

output "instance_connection_name" {
  description = "Nome de conexão da instância (para Cloud SQL Proxy)"
  value       = google_sql_database_instance.postgres.connection_name
}

output "instance_ip_address" {
  description = "Endereço IP público da instância"
  value       = google_sql_database_instance.postgres.public_ip_address
}

output "instance_private_ip_address" {
  description = "Endereço IP privado da instância"
  value       = google_sql_database_instance.postgres.private_ip_address
}

output "database_name" {
  description = "Nome do banco de dados"
  value       = google_sql_database.database.name
}

output "database_user" {
  description = "Usuário do banco de dados"
  value       = google_sql_user.user.name
}

output "connection_string" {
  description = "String de conexão do banco de dados"
  value       = "postgres://${google_sql_user.user.name}:${var.database_password}@${google_sql_database_instance.postgres.private_ip_address}:5432/${google_sql_database.database.name}"
  sensitive   = true
}

output "connection_string_public" {
  description = "String de conexão pública do banco de dados"
  value       = "postgres://${google_sql_user.user.name}:${var.database_password}@${google_sql_database_instance.postgres.public_ip_address}:5432/${google_sql_database.database.name}"
  sensitive   = true
}

