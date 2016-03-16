# terraform-aws-memcached-elasticache

A Terraform module to create an Amazon Web Services (AWS) Memcached ElastiCache cluster.

## Usage

```javascript
module "memcached_elasticache" {
  source = "github.com/azavea/terraform-aws-memcached-elasticache"

  vpc_id = "vpc-20f74844"

  cache_name = "cache"
  cache_nodes = "2"
  engine_version = "1.4.24"
  instance_type = "cache.t2.micro"
  maintenance_window = "sun:05:00-sun:06:00"

  private_subnet_ids = "subnet-4a887f3c,subnet-76dae35d"

  alarm_actions = "arn:aws:sns..."
}
```

## Variables

- `vpc_id` - ID of VPC meant to house the cache
- `cache_name` - Name used as ElastiCache cluster ID
- `cache_nodes` - Number of nodes in the cache cluster
- `engine_version` - Cache engine version (default: `1.4.24`)
- `instance_type` - Instance type for cache instance (default: `cache.t2.micro`)
- `maintenance_window` - 60 minute time window to reserve for maintenance
  (default: `sun:05:00-sun:06:00`)
- `private_subnet_ids` - Comma delimited list of private subnet IDs
- `alarm_actions` - Comma delimited list of ARNs to be notified via CloudWatch

## Outputs

- `cache_security_group_id` - Security group ID of the cache cluster
- `configuration_endpoint` - Configuration endpoint to allow for host discovery
