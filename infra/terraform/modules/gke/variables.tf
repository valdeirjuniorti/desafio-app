variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região GCP onde o cluster será criado"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Nome do cluster GKE"
  type        = string
  default     = "desafio-app-gke"
}

variable "vpc_name" {
  description = "Nome da VPC onde o cluster será criado"
  type        = string
}

variable "subnet_primary_name" {
  description = "Nome da subnet primária"
  type        = string
}

variable "subnet_secondary_name" {
  description = "Nome da subnet secundária"
  type        = string
}

variable "subnet_primary_pods_range" {
  description = "Range de IPs para pods na subnet primária"
  type        = string
}

variable "subnet_primary_services_range" {
  description = "Range de IPs para services na subnet primária"
  type        = string
}

variable "subnet_secondary_pods_range" {
  description = "Range de IPs para pods na subnet secundária"
  type        = string
}

variable "subnet_secondary_services_range" {
  description = "Range de IPs para services na subnet secundária"
  type        = string
}

variable "cluster_service_account_email" {
  description = "Email da service account do cluster"
  type        = string
}

variable "node_service_account_email" {
  description = "Email da service account dos nodes"
  type        = string
}

variable "min_node_count" {
  description = "Número mínimo de nodes no node pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Número máximo de nodes no node pool"
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "Tipo de máquina para os nodes"
  type        = string
  default     = "e2-medium"
}

variable "disk_size_gb" {
  description = "Tamanho do disco em GB para cada node"
  type        = number
  default     = 30
}

variable "disk_type" {
  description = "Tipo de disco (pd-standard, pd-ssd)"
  type        = string
  default     = "pd-standard"
}

variable "gke_version" {
  description = "Versão do GKE (deixe vazio para usar a versão padrão)"
  type        = string
  default     = null
}

variable "enable_private_nodes" {
  description = "Habilitar nodes privados (sem IP público)"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Habilitar endpoint privado do cluster"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block para o master do GKE"
  type        = string
  default     = "172.16.0.0/28"
}

variable "environment" {
  description = "Ambiente (dev, hml, prd)"
  type        = string
}

