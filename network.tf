resource "google_compute_network" "vpc_network" {
  name                    = "vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary_subnet" {
  name                     = "subnetwork"
  ip_cidr_range            = "192.168.0.0/20"
  region                   = "us-central1"
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.primary_subnet.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}