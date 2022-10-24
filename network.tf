resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "primary_subnet" {
  count                    = var.create_gke_subnet ? 1 : 0
  name                     = var.gke_subnet_name
  ip_cidr_range            = var.gke_subnet_ip_cidr_range
  region                   = var.region
  project                  = var.project_id
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "${var.gke_subnet_name}-gke-pods"
    ip_cidr_range = var.gke_subnet_ip_range_pods
  }
  secondary_ip_range {
    range_name    = "${var.gke_subnet_name}-gke-services"
    ip_cidr_range = var.gke_subnet_ip_range_services
  }

  depends_on = [module.project_services]
}


resource "google_compute_router" "router" {
  name    = "router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}