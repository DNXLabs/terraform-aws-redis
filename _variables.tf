variable "name" {
  description = "Name of this Redis"
  type        = string
}

variable "automatic_failover_enabled" {
  type    = bool
  default = false
}

variable "at_rest_encryption_enabled" {
  type    = bool
  default = false
}

variable "transit_encryption_enabled" {
  default = false
}

# variable "auth_token" {
#   default = ""
# }

variable "multi_az_enabled" {
  default = false
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "port" {
  description = "Port number for this Redis"
  type        = number
  default     = 6379
}

variable "kms_key_id" {
  description = "KMS Key ARN to use a CMK instead of default shared key"
  default     = null
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed"
  default     = "sun:05:00-sun:07:00"
}

variable "node_type" {
  description = "The instance class to be used"
  type        = string
}

variable "notification_topic_arn" {
  default = ""
}

variable "number_cache_clusters" {
  description = "The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2"
  default     = 1
}

variable "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them"
  default     = 0
}

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period"
  default     = "03:00-04:00"
}

variable "subnet_group_name" {
  description = "The name of the cache subnet group to be used for the replication group"
  type        = string
}

variable "parameter_group_name" {
  description = "The name of the parameter group to associate with this replication group"
  type        = string
  default     = null
}

variable "environment_name" {
  description = "Environment name to use as a prefix to this Redis"
  type        = string
}

variable "allow_security_group_ids" {
  description = "List of Security Group IDs to allow connection to this Redis"
  type        = list(string)
  default     = []
}

variable "allow_cidrs" {
  description = "List of CIDRs to allow connection to this DB"
  type        = list(string)
  default     = []
}

variable "create_subnet_group" {
  description = "Create a subnet group"
  default     = false
}

variable "subnet_ids" {
  description = "List of Subnet IDs for the RDS Subnet Group"
  type        = list(any)
  default     = []
}

variable "vpc_id" {
  type = string
}

variable "secret_method" {
  description = "Use ssm for SSM parameters store which is the default option, or secretsmanager for AWS Secrets Manager"
  type        = string
  default     = "ssm"
}