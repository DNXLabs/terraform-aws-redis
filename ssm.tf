resource "aws_ssm_parameter" "redis_endpoint" {
  count       = var.secret_method == "ssm" ? 1 : 0
  name        = "/redis/${var.name}/ENDPOINT"
  description = "Redis Endpoint"
  type        = "String"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

resource "aws_ssm_parameter" "redis_password" {
  count       = var.secret_method == "ssm" && var.transit_encryption_enabled ? 1 : 0
  name        = "/redis/${var.name}/PASSWORD"
  description = "Redis Password"
  type        = "SecureString"
  value = random_string.redis_password[0].result

  lifecycle {
    ignore_changes = [value]
  }
}