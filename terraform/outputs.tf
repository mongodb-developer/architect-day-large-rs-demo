output "cluster_name" {
  value       = mongodbatlas_advanced_cluster.global_rs.name
  description = "Cluster name"
}

output "standard_connection_string" {
  value       = local.effective_mongodb_uri
  description = "Base SRV connection string without credentials"
  sensitive   = false
}
