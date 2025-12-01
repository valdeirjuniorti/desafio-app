variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região GCP onde o Cloud SQL será criado"
  type        = string
  default     = "us-central1"
}

variable "database_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "desafios"
}

variable "database_user" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "desafios_user"
}

variable "database_password" {
  description = "Senha do banco de dados (deve ser fornecida via variável de ambiente ou secret)"
  type        = string
  sensitive   = true
}

variable "instance_name" {
  description = "Nome da instância Cloud SQL"
  type        = string
  default     = "desafio-app-postgres"
}

variable "tier" {
  description = "Tier da instância (db-f1-micro, db-n1-standard-1, etc)"
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size" {
  description = "Tamanho do disco em GB"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "Tipo de disco (PD_SSD ou PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "backup_enabled" {
  description = "Habilitar backups automáticos"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "Horário de início do backup (HH:MM formato UTC)"
  type        = string
  default     = "03:00"
}

variable "high_availability" {
  description = "Habilitar alta disponibilidade (replicação)"
  type        = bool
  default     = false
}

variable "vpc_name" {
  description = "Nome da VPC para conectar o Cloud SQL"
  type        = string
}

variable "authorized_networks" {
  description = "Lista de redes autorizadas para acessar o Cloud SQL"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "environment" {
  description = "Ambiente (dev, hml, prd)"
  type        = string
}

variable "postgres_version" {
  description = "Versão do PostgreSQL"
  type        = string
  default     = "POSTGRES_15"
}

