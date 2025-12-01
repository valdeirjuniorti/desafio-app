terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
  }
}

locals {
  project_id = "seu-projeto-gcp"
  region     = "us-central1"
  environment = "dev"
}

provider "google" {
  project = local.project_id
  region  = local.region
}

module "vpc" {
  source = "../../modules/vpc"

  project_id           = local.project_id
  region              = local.region
  vpc_name            = "desafio-app-vpc-${local.environment}"
  subnet_cidr_primary = "10.0.1.0/24"
  subnet_cidr_secondary = "10.0.2.0/24"
  enable_nat          = true
  environment         = local.environment
}

module "security" {
  source = "../../modules/security"

  project_id   = local.project_id
  cluster_name = "desafio-app-gke-${local.environment}"
  environment  = local.environment
}

module "cloud_sql" {
  source = "../../modules/psql"

  project_id        = local.project_id
  region           = local.region
  instance_name    = "desafio-app-postgres-${local.environment}"
  database_name    = "desafios"
  database_user    = "desafios_user"
  database_password = var.database_password
  tier            = "db-f1-micro"
  disk_size       = 20
  backup_enabled  = true
  high_availability = false
  vpc_name        = module.vpc.vpc_name
  environment     = local.environment
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id   = local.project_id
  region      = local.region
  registry_name = "desafio-app"
  environment  = local.environment

  node_service_account_email = module.security.node_service_account_email

  enable_immutable_tags = local.environment == "prd"
  enable_public_read = false
  enable_authenticated_read = false
}

module "gke" {
  source = "../../modules/gke"

  project_id   = local.project_id
  region      = local.region
  cluster_name = "desafio-app-gke-${local.environment}"

  vpc_name                    = module.vpc.vpc_name
  subnet_primary_name         = module.vpc.subnet_primary_name
  subnet_secondary_name       = module.vpc.subnet_secondary_name
  subnet_primary_pods_range   = module.vpc.subnet_primary_pods_range
  subnet_primary_services_range = module.vpc.subnet_primary_services_range
  subnet_secondary_pods_range = module.vpc.subnet_secondary_pods_range
  subnet_secondary_services_range = module.vpc.subnet_secondary_services_range

  cluster_service_account_email = module.security.cluster_service_account_email
  node_service_account_email    = module.security.node_service_account_email

  min_node_count = 1
  max_node_count = 3
  machine_type   = "e2-medium"
  disk_size_gb   = 30

  enable_private_nodes  = true
  enable_private_endpoint = false

  environment = local.environment
}
