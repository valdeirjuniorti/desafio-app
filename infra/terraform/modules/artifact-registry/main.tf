resource "google_project_service" "artifactregistry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"

  disable_dependent_services = false
}

resource "google_artifact_registry_repository" "registry" {
  location      = var.region
  repository_id = "${var.registry_name}-${var.environment}"
  description   = var.description
  format        = var.repository_format
  project       = var.project_id

  labels = merge(
    {
      environment = var.environment
    },
    var.labels
  )

  docker_config {
    immutable_tags = var.enable_immutable_tags
  }

  depends_on = [google_project_service.artifactregistry_api]
}

resource "google_artifact_registry_repository_iam_member" "registry_reader" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.node_service_account_email}"
}

resource "google_artifact_registry_repository_iam_member" "registry_writer" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${var.node_service_account_email}"
}

resource "google_artifact_registry_repository_iam_member" "registry_admin" {
  count = var.enable_admin_access ? 1 : 0

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.admin"
  member     = "serviceAccount:${var.admin_service_account_email}"
}

resource "google_artifact_registry_repository_iam_member" "registry_ci_cd" {
  count = var.ci_cd_service_account_email != null ? 1 : 0

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${var.ci_cd_service_account_email}"
}

resource "google_artifact_registry_repository_iam_member" "registry_reader_public" {
  count = var.enable_public_read ? 1 : 0

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.reader"
  member     = "allUsers"
}

resource "google_artifact_registry_repository_iam_member" "registry_reader_authenticated" {
  count = var.enable_authenticated_read ? 1 : 0

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.reader"
  member     = "allAuthenticatedUsers"
}
