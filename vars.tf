variable "project_id" {
  type = string
}

variable "private_cluster" {
  type    = bool
  default = true
}

variable "pods_ipv4_cidr_block_01" {
  type = string
}

variable "services_ipv4_cidr_block_01" {
  type = string
}

variable "pods_ipv4_cidr_block_02" {
  type = string
}

variable "services_ipv4_cidr_block_02" {
  type = string
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
