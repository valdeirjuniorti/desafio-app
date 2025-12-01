variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região GCP onde os recursos serão criados"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
  default     = "desafio-app-vpc"
}

variable "subnet_cidr_primary" {
  description = "CIDR da subnet primária"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_secondary" {
  description = "CIDR da subnet secundária (para alta disponibilidade)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "enable_nat" {
  description = "Habilitar NAT Gateway para acesso à internet"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Ambiente (dev, hml, prd)"
  type        = string
}

