output "cluster_id" {
  value = google_container_cluster.primary.id
}

output "location" {
  value = google_container_cluster.primary.location
}