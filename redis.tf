resource "random_string" "redis_password" {
  count   = var.transit_encryption_enabled ? 1 : 0
  length  = 34
  special = false
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = var.name
  replication_group_description = var.name
  automatic_failover_enabled    = var.automatic_failover_enabled
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  multi_az_enabled              = var.multi_az_enabled
  # auth_token                    = var.transit_encryption_enabled ? var.auth_token != null ? var.auth_token : random_string.redis_password[0].result : null
  auth_token               = var.transit_encryption_enabled ? random_string.redis_password[0].result : null
  engine                   = var.engine
  engine_version           = var.engine_version
  kms_key_id               = var.kms_key_id
  maintenance_window       = var.maintenance_window
  node_type                = var.node_type
  notification_topic_arn   = var.notification_topic_arn
  number_cache_clusters    = var.number_cache_clusters
  port                     = var.port
  security_group_ids       = [aws_security_group.redis.id]
  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window
  subnet_group_name        = try(aws_elasticache_subnet_group.redis[0].name, var.subnet_group_name)
  parameter_group_name     = var.parameter_group_name
  user_group_ids           = var.user_group_ids

  tags = {
    "Name"    = var.name
    "EnvName" = var.environment_name
  }
}