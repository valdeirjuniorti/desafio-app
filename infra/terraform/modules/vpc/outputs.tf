output "vpc_id" {
  description = "ID da VPC criada"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "Nome da VPC"
  value       = google_compute_network.vpc.name
}

output "subnet_primary_id" {
  description = "ID da subnet primária"
  value       = google_compute_subnetwork.subnet_primary.id
}

output "subnet_primary_name" {
  description = "Nome da subnet primária"
  value       = google_compute_subnetwork.subnet_primary.name
}

output "subnet_secondary_id" {
  description = "ID da subnet secundária"
  value       = google_compute_subnetwork.subnet_secondary.id
}

output "subnet_secondary_name" {
  description = "Nome da subnet secundária"
  value       = google_compute_subnetwork.subnet_secondary.name
}

output "subnet_primary_pods_range" {
  description = "Range de IPs para pods na subnet primária"
  value       = google_compute_subnetwork.subnet_primary.secondary_ip_range[0].range_name
}

output "subnet_primary_services_range" {
  description = "Range de IPs para services na subnet primária"
  value       = google_compute_subnetwork.subnet_primary.secondary_ip_range[1].range_name
}

output "subnet_secondary_pods_range" {
  description = "Range de IPs para pods na subnet secundária"
  value       = google_compute_subnetwork.subnet_secondary.secondary_ip_range[0].range_name
}

output "subnet_secondary_services_range" {
  description = "Range de IPs para services na subnet secundária"
  value       = google_compute_subnetwork.subnet_secondary.secondary_ip_range[1].range_name
}

output "router_name" {
  description = "Nome do router (se NAT estiver habilitado)"
  value       = var.enable_nat ? google_compute_router.router[0].name : null
}

