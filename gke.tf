resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  provider                 = google-beta
  name                     = var.gke_cluster_name
  location                 = var.location
  initial_node_count       = 1
  remove_default_node_pool = true
  release_channel {
    channel = "STABLE"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.pods_ipv4_cidr_block_01
    services_ipv4_cidr_block = var.services_ipv4_cidr_block_01
  }

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.primary_subnet.id

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  workload_identity_config {
    workload_pool = format("%s.svc.id.goog", var.project_id)
  }

  cluster_autoscaling {
    enabled = false
    # autoscaling_profile = "OPTIMIZE_UTILIZATION"
    # resource_limits {
    #   resource_type = "cpu"
    #   minimum = 1
    #   maximum = 4
    # }
    # resource_limits {
    #   resource_type = "memory"
    #   minimum = 2
    #   maximum = 8
    # }
  } 
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  provider   = google-beta
  name       = "spot-node-pool"
  location   = var.location
  cluster    = google_container_cluster.primary.name

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_type = "pd-ssd"

    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"

    ]
    metadata = {
      "disable-legacy-endpoints" = "true"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

  }
}

