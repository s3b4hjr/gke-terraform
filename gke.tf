locals {
  default_labels = {
    environment = var.environment
  }
}

module "gke" {
  count   = var.create_gke_cluster ? 1 : 0
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "22.1.0"

  kubernetes_version = var.gke_k8s_version

  project_id = var.project_id
  name       = var.gke_cluster_name
  regional   = false
  region     = var.region
  zones      = var.zones

  network           = var.vpc_name
  subnetwork        = var.subnetwork
  ip_range_pods     = "${var.gke_subnet_name}-gke-pods"
  ip_range_services = "${var.gke_subnet_name}-gke-services"

  create_service_account     = false
  remove_default_node_pool   = true
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block

  node_pools_oauth_scopes = var.gke_node_pools_oauth_scopes
  node_pools_labels       = var.gke_node_pools_labels
  node_pools_metadata     = var.gke_node_pools_metadata
  node_pools_taints       = var.gke_node_pools_taints
  node_pools_tags         = var.gke_node_pools_tags

  add_shadow_firewall_rules      = true
  shadow_firewall_rules_priority = 700

  add_cluster_firewall_rules = true
  firewall_priority          = 700
  firewall_inbound_ports = [
    "8080",
    "443",
    "10250",
    "15000",
    "15010",
    "15012",
    "15014",
    "15017",
  ]

  cluster_resource_labels = merge(local.default_labels, {
    mesh_id = "proj-${data.google_project.project.number}"
  })

  depends_on = [
    google_compute_subnetwork.primary_subnet
  ]

  node_pools = [
    {
      name               = "spot-node-pool"
      machine_type       = "e2-medium"
      node_locations     = var.location
      initial_node_count = 1
      min_count          = 1
      max_count          = 4
      local_ssd_count    = 0
      spot               = true
      preemptible        = false
      disk_size_gb       = 100
      disk_type          = "pd-ssd"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = false
    },
  ]
}