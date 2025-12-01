resource "google_project_service" "iam_api" {
  project = var.project_id
  service = "iam.googleapis.com"

  disable_dependent_services = false
}

resource "google_service_account" "cluster_sa" {
  account_id   = "${var.cluster_name}-cluster-sa"
  display_name = "Service Account para o cluster GKE"
  project     = var.project_id

  depends_on = [google_project_service.iam_api]
}

resource "google_service_account" "node_sa" {
  account_id   = "${var.cluster_name}-node-sa"
  display_name = "Service Account para os nodes do GKE"
  project      = var.project_id

  depends_on = [google_project_service.iam_api]
}

resource "google_project_iam_member" "cluster_sa_compute" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.cluster_sa.email}"

  depends_on = [google_service_account.cluster_sa]
}

resource "google_project_iam_member" "cluster_sa_container" {
  project = var.project_id
  role    = "roles/container.clusterAdmin"
  member  = "serviceAccount:${google_service_account.cluster_sa.email}"

  depends_on = [google_service_account.cluster_sa]
}

resource "google_project_iam_member" "node_sa_compute" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.node_sa.email}"

  depends_on = [google_service_account.node_sa]
}

resource "google_project_iam_member" "node_sa_storage" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.node_sa.email}"

  depends_on = [google_service_account.node_sa]
}

resource "google_project_iam_member" "node_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.node_sa.email}"

  depends_on = [google_service_account.node_sa]
}

resource "google_project_iam_member" "node_sa_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.node_sa.email}"

  depends_on = [google_service_account.node_sa]
}

resource "google_project_iam_member" "node_sa_monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.node_sa.email}"

  depends_on = [google_service_account.node_sa]
}

resource "google_project_iam_member" "node_sa_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.node_sa.email}"

  depends_on = [google_service_account.node_sa]
}

resource "google_project_iam_member" "node_sa_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.node_sa.email}"

  depends_on = [google_service_account.node_sa]
}
