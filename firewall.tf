resource "google_compute_firewall" "deny_all" {
  deny {
    protocol = "all"
  }
  description   = "Deny all rule."
  direction     = "INGRESS"
  disabled      = "false"
  name          = "deny"
  network       = google_compute_network.vpc_network.id
  priority      = "900"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "acesso_cloudflare" {
  allow {
    ports    = ["443"]
    protocol = "tcp"
  }

  direction = "INGRESS"
  disabled  = "false"

#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }

  name          = "acesso-cloudflare"
  network       = google_compute_network.vpc_network.id
  priority      = "1"
  project       = var.project_id
  source_ranges = ["103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "104.16.0.0/12", "108.162.192.0/18", "131.0.72.0/22", "141.101.64.0/18", "162.158.0.0/15", "172.64.0.0/13", "173.245.48.0/20", "188.114.96.0/20", "190.93.240.0/20", "197.234.240.0/22", "198.41.128.0/17"]
}

resource "google_compute_firewall" "internal" {
  allow {
    protocol = "all"
  }

  direction     = "INGRESS"
  disabled      = "false"
  name          = "internal"
  network       = google_compute_network.vpc_network.id
  priority      = "1"
  project       = var.project_id
  source_ranges = [ var.gke_subnet_ip_cidr_range, 
                    var.gke_subnet_ip_range_pods
                ]
}