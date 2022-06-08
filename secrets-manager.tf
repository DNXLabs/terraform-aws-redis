locals {
  secrets = {
    primary_endpoint = aws_elasticache_replication_group.redis.primary_endpoint_address
    reader_endpoint  = aws_elasticache_replication_group.redis.reader_endpoint_address
    password         = var.transit_encryption_enabled ? random_string.redis_password[0].result : ""
    identifier       = aws_elasticache_replication_group.redis.id
    engine           = aws_elasticache_replication_group.redis.engine
  }
}

resource "aws_secretsmanager_secret" "redis" {
  count                   = var.secret_method == "secretsmanager" ? 1 : 0
<<<<<<< HEAD
  name                    = "/cache/${var.name}"
=======
  name                    = "/redis/${var.name}"
>>>>>>> c04a62814a91430591620301d22491be7589817e
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "redis" {
  count         = var.secret_method == "secretsmanager" ? 1 : 0
  secret_id     = aws_secretsmanager_secret.redis[0].id
  secret_string = jsonencode(local.secrets)
}
