#############################
# MongoDB Atlas Project
#############################

locals {
  project_id = var.atlas_project_id
  # Global random suffix to ensure resource name uniqueness
  cluster_name_effective = "${var.cluster_name}-${random_id.demo_suffix.hex}"
}

#############################
# Advanced (Replica Set) Cluster
#############################

# The advanced cluster resource supports global multi-region replica sets.
resource "mongodbatlas_advanced_cluster" "global_rs" {
  project_id                     = local.project_id
  name                           = local.cluster_name_effective
  cluster_type                   = "REPLICASET" # Change to SHARDED for one-shard demo
  backup_enabled                 = var.cluster_backup_enabled
  pit_enabled                    = var.cluster_backup_enabled
  termination_protection_enabled = false
  mongo_db_major_version         = var.mongo_db_major_version

  replication_specs = [
    {
      zone_name = "Zone Uno"
      region_configs = [
        {
          provider_name = "AWS"
          region_name   = "US_EAST_1"
          priority      = 7
          electable_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 3
          }
          read_only_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 0
          }
          analytics_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 0
          }
        },
        {
          provider_name = "AWS"
          region_name   = "US_EAST_2"
          priority      = 6
          electable_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 2
          }
          read_only_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 0
          }
          analytics_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 0
          }
        },
        {
          provider_name = "AWS"
          region_name   = "AP_SOUTHEAST_2"
          priority      = 0
          electable_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 0
          }
          read_only_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 1
          }
          analytics_specs = {
            instance_size = var.cluster_instance_size
            node_count    = 0
          }
        }
      ]
    }
  ]
}


#############################
# Outputs / Helpful Data
#############################

data "mongodbatlas_advanced_cluster" "conn_strings" {
  project_id = local.project_id
  name       = local.cluster_name_effective
  depends_on = [mongodbatlas_advanced_cluster.global_rs]
}

locals {
  effective_mongodb_uri = try(
    data.mongodbatlas_advanced_cluster.conn_strings.connection_strings.standard_srv,
    ""
  )
}

# Shared random suffix to ensure globally-unique names across resources
resource "random_id" "demo_suffix" {
  byte_length = 2 # 4 hex chars
}
