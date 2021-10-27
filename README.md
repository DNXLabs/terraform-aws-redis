# terraform-aws-redis

[![Lint Status](https://github.com/DNXLabs/terraform-aws-rds/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-rds/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-redis)](https://github.com/DNXLabs/terraform-aws-redis/blob/master/LICENSE)

## Usage
```
cache:
      redis:
        - name: namexyz
          environment_name: dev
          ecs_cluster_names:
            - "dev-apps"
          node_type: cache.t2.micro
          parameter_group_name: default.redis6.x
          engine_version: 6.x
          transit_encryption_enabled: false
          enabled: true
```

```hcl
resource "aws_kms_key" "redis_key" {}

resource "aws_kms_alias" "redis_alias" {
  name          = "alias/redis-${local.workspace.environment_name}"
  target_key_id = aws_kms_key.redis_key.key_id
}

module "cache_redis" {
  source                        = "git::https://github.com/DNXLabs/terraform-aws-redis.git"
  for_each                      = { for redis in local.workspace.cache.redis : redis.name => redis }
  
  name                          = "redis-${each.value.environment_name}"
  environment_name              = each.value.environment_name
  automatic_failover_enabled    = try(each.value.automatic_failover_enabled, false)
  at_rest_encryption_enabled    = try(each.value.at_rest_encryption_enabled, false)
  transit_encryption_enabled    = try(each.value.transit_encryption_enabled, false)
  multi_az_enabled              = try(each.value.multi_az_enabled, false)
  engine                        = try(each.value.engine, "redis")
  engine_version                = each.value.engine_version
  kms_key_id                    = try(each.value.at_rest_encryption_enabled, false ) ? aws_kms_key.redis_key.arn : ""
  maintenance_window            = try(each.value.maintenance_window, "sun:05:00-sun:07:00")
  node_type                     = each.value.node_type
  notification_topic_arn        = try(each.value.notification_topic_arn, "")
  number_cache_clusters         = try(each.value.number_cache_clusters, 1)
  port                          = try(each.value.port, 6379)
  snapshot_retention_limit      = try(each.value.snapshot_retention_limit, 0)
  snapshot_window               = try(each.value.snapshot_window, "03:00-04:00")
  parameter_group_name          = each.value.parameter_group_name
  create_subnet_group           = try(each.value.create_subnet_group, true)
  subnet_group_name             = "${each.value.environment_name}-cachesubnet"
  
  allow_security_group_ids = concat(
    [for cluster_name in try(each.value.ecs_cluster_names, []) : module.ecs_cluster[cluster_name].ecs_nodes_secgrp_id], []
  )

  allow_cidrs        = try(each.value.allow_cidrs, [local.common.vpn_cidr])
  subnet_ids         = data.aws_subnet_ids.secure.ids
  vpc_id             = data.aws_vpc.selected.id
  
}
```


<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_cidrs | List of CIDRs to allow connection to this DB | `list(string)` | `[]` | no |
| allow\_security\_group\_ids | List of Security Group IDs to allow connection to this Redis | `list(string)` | `[]` | no |
| at\_rest\_encryption\_enabled | n/a | `bool` | `false` | no |
| automatic\_failover\_enabled | n/a | `bool` | `false` | no |
| create\_subnet\_group | Create a subnet group | `bool` | `false` | no |
| engine | n/a | `string` | n/a | yes |
| engine\_version | n/a | `string` | n/a | yes |
| environment\_name | Environment name to use as a prefix to this Redis | `string` | n/a | yes |
| kms\_key\_id | KMS Key ARN to use a CMK instead of default shared key | `any` | `null` | no |
| maintenance\_window | Specifies the weekly time range for when maintenance on the cache cluster is performed | `string` | `"sun:05:00-sun:07:00"` | no |
| multi\_az\_enabled | n/a | `bool` | `false` | no |
| name | Name of this Redis | `string` | n/a | yes |
| node\_type | The instance class to be used | `string` | n/a | yes |
| notification\_topic\_arn | n/a | `string` | `""` | no |
| number\_cache\_clusters | The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2 | `number` | `1` | no |
| parameter\_group\_name | The name of the parameter group to associate with this replication group | `string` | `null` | no |
| port | Port number for this Redis | `number` | `6379` | no |
| snapshot\_retention\_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them | `number` | `0` | no |
| snapshot\_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period | `string` | `"03:00-04:00"` | no |
| subnet\_group\_name | The name of the cache subnet group to be used for the replication group | `string` | n/a | yes |
| subnet\_ids | List of Subnet IDs for the RDS Subnet Group | `list(any)` | `[]` | no |
| transit\_encryption\_enabled | n/a | `bool` | `false` | no |
| vpc\_id | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |
| redis\_endpoint | n/a |
| redis\_sg | n/a |

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE) for full details.