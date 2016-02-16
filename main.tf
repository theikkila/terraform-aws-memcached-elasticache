#
# Security group resources
#

resource "aws_security_group" "memcached" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "sgCacheCluster"
  }
}

resource "aws_security_group_rule" "memcached_ingress" {
    type = "ingress"
    from_port = 11211
    to_port = 11211
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]

    security_group_id = "${aws_security_group.memcached.id}"
}

resource "aws_security_group_rule" "memcached_egress" {
    type = "egress"
    from_port = 11211
    to_port = 11211
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]

    security_group_id = "${aws_security_group.memcached.id}"
}

#
# ElastiCache resources
#

resource "aws_elasticache_cluster" "memcached" {
  cluster_id = "${var.cache_name}"
  engine = "memcached"
  engine_version = "${var.engine_version}"
  maintenance_window = "${var.maintenance_window}"
  node_type = "${var.instance_type}"
  num_cache_nodes = "${var.cache_nodes}"
  parameter_group_name = "default.memcached1.4"
  port = "11211"
  subnet_group_name = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids = ["${aws_security_group.memcached.id}"]

  tags {
    Name = "CacheCluster"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name = "${var.cache_name}-subnet-group"
  description = "Private subnets for the ElastiCache instances"
  subnet_ids = ["${split(",", var.private_subnet_ids)}"]
}

#
# CloudWatch resources
#

resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name = "alarmCacheClusterCPUUtilization"
  alarm_description = "Cache cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ElastiCache"
  period = "300"
  statistic = "Average"
  threshold = "75"
  dimensions {
    CacheClusterId = "${aws_elasticache_cluster.memcached.id}"
  }
  alarm_actions = ["${split(",", var.alarm_actions)}"]
}

resource "aws_cloudwatch_metric_alarm" "memory_free" {
  alarm_name = "alarmCacheClusterFreeableMemory"
  alarm_description = "Cache cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "FreeableMemory"
  namespace = "AWS/ElastiCache"
  period = "60"
  statistic = "Average"
  # 10MB in bytes
  threshold = "10000000"
  dimensions {
    CacheClusterId = "${aws_elasticache_cluster.memcached.id}"
  }
  alarm_actions = ["${split(",", var.alarm_actions)}"]
}
