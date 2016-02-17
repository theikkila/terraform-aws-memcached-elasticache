output "cache_security_group_id" {
  value = "${aws_security_group.memcached.id}"
}

output "configuration_endpoint" {
  value = "${aws_elasticache_cluster.memcached.configuration_endpoint}"
}
