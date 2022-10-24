variable "project_id" {
  type = string
}

variable "private_cluster" {
  type    = bool
  default = true
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "location" {
  type = string
}

variable "gke_cluster_name" {
  type = string
}   
variable "active_apis" {
  type        = list(string)
  description = "(optional)"
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "iamcredentials.googleapis.com",
    "stackdriver.googleapis.com",
    "sts.googleapis.com",
  ]
}

variable "install_asm" {
  type        = bool
  default     = true
  description = "(optional)"
}

variable "create_gke_cluster" {
  type        = bool
  default     = true
  description = "(optional)"
}

variable "gke_node_pools_oauth_scopes" {
  type        = map(any)
  default     = {}
  description = "(optional)"
}
variable "gke_node_pools_labels" {
  type        = map(any)
  default     = {}
  description = "(optional)"
}
variable "gke_node_pools_metadata" {
  type        = map(any)
  default     = {}
  description = "(optional)"
}
variable "gke_node_pools_taints" {
  type        = map(any)
  default     = {}
  description = "(optional)"
}
variable "gke_node_pools_tags" {
  type        = map(any)
  default     = {}
  description = "(optional)"
}

variable "gke_k8s_version" {
  type        = string
  description = "(optional)"
  default     = "1.23"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "region" {
  description = "The region to host the cluster in"
  default = "us-central1"
}

variable "zones" {
  default = ["us-central1-a"]
}


variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  default = "subnetwork"
}

variable "create_gke_subnet" {
  type        = bool
  default     = true
  description = "(optional)"
}
variable "gke_subnet_name" {
  type        = string
  description = "(required)"
}
variable "gke_subnet_ip_cidr_range" {
  type        = string
  description = "(required)"
}
variable "gke_subnet_ip_range_pods" {
  type        = string
  description = "(required)"
}
variable "gke_subnet_ip_range_services" {
  type        = string
  description = "(required)"
}

variable "vpc_name" {
  type = string
  default = "vpc"
}

variable "asm_version" {
  default = "$ASM_MAJOR_VERSION"
}