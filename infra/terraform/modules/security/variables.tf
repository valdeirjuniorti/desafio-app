variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, hml, prd)"
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster GKE"
  type        = string
  default     = "desafio-app-gke"
}

