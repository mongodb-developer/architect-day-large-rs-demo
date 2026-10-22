variable "atlas_project_id" {
  type        = string
  description = "Existing MongoDB Atlas Project ID (24-hex). Required."
  default     = ""
  validation {
    condition     = length(var.atlas_project_id) > 0 && length(regexall("^[a-f0-9]{24}$", var.atlas_project_id)) > 0
    error_message = "Set TF_VAR_atlas_project_id to a valid 24-character hex Atlas Project ID."
  }
}

variable "cluster_name" {
  type        = string
  description = "Name of the Atlas cluster (advanced / replica set)."
  default     = "global-rs"
}

variable "cluster_instance_size" {
  type        = string
  description = "Atlas instance size (e.g. M10, M30). Use M30+ for multi-region replica sets."
  default     = "M30"

}

variable "cluster_backup_enabled" {
  type        = bool
  description = "Enable cloud backups (Continuous Backup / PITR)."
  default     = true
}

variable "mongo_db_major_version" {
  type        = string
  description = "MongoDB major version for the advanced cluster (e.g. 9.0, 8.0)."
  default     = "8.0"
}


