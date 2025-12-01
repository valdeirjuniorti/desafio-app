resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id

  depends_on = [google_project_service.compute_api]
}

resource "google_compute_subnetwork" "subnet_primary" {
  name          = "${var.vpc_name}-subnet-primary"
  ip_cidr_range = var.subnet_cidr_primary
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/20"
  }
}

resource "google_compute_subnetwork" "subnet_secondary" {
  name          = "${var.vpc_name}-subnet-secondary"
  ip_cidr_range = var.subnet_cidr_secondary
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.3.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.4.0.0/20"
  }
}

resource "google_compute_router" "router" {
  count   = var.enable_nat ? 1 : 0
  name    = "${var.vpc_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  count                              = var.enable_nat ? 1 : 0
  name                               = "${var.vpc_name}-nat"
  router                             = google_compute_router.router[0].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  project                            = var.project_id

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [
    var.subnet_cidr_primary,
    var.subnet_cidr_secondary,
    "10.1.0.0/16",
    "10.2.0.0/20",
    "10.3.0.0/16",
    "10.4.0.0/20"
  ]

  target_tags = ["internal"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "${var.vpc_name}-allow-http-https"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}

resource "google_compute_firewall" "allow_gke" {
  name    = "${var.vpc_name}-allow-gke"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["10250", "443"]
  }

  source_ranges = [
    var.subnet_cidr_primary,
    var.subnet_cidr_secondary
  ]

  target_tags = ["gke-node"]
}

resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"

  disable_dependent_services = false
}
