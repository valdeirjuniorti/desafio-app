variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região GCP onde o registry será criado"
  type        = string
  default     = "us-central1"
}

variable "registry_name" {
  description = "Nome do Artifact Registry"
  type        = string
  default     = "desafio-app-registry"
}

variable "repository_format" {
  description = "Formato do repositório (DOCKER, NPM, MAVEN, PYTHON, etc)"
  type        = string
  default     = "DOCKER"
}

variable "description" {
  description = "Descrição do registry"
  type        = string
  default     = "Registry para imagens Docker do desafio-app"
}

variable "labels" {
  description = "Labels para o registry"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Ambiente (dev, hml, prd)"
  type        = string
}

variable "enable_immutable_tags" {
  description = "Habilitar tags imutáveis (recomendado para produção)"
  type        = bool
  default     = false
}

variable "enable_vulnerability_scanning" {
  description = "Habilitar scan de vulnerabilidades automático"
  type        = bool
  default     = true
}

variable "node_service_account_email" {
  description = "Email da service account dos nodes do GKE"
  type        = string
}

variable "enable_admin_access" {
  description = "Habilitar acesso admin para service account específica"
  type        = bool
  default     = false
}

variable "admin_service_account_email" {
  description = "Email da service account com acesso admin (requerido se enable_admin_access = true)"
  type        = string
  default     = null
}

variable "ci_cd_service_account_email" {
  description = "Email da service account do CI/CD para push de imagens"
  type        = string
  default     = null
}

variable "enable_public_read" {
  description = "Habilitar leitura pública do registry (não recomendado para produção)"
  type        = bool
  default     = false
}

variable "enable_authenticated_read" {
  description = "Habilitar leitura para usuários autenticados"
  type        = bool
  default     = false
}

