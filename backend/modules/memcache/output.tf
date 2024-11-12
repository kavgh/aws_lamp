output "address" {
  description = "The address for connecting to MC"
  value       = aws_elasticache_cluster.this.cluster_address
}

output "port" {
  description = "The port number of the memcache"
  value       = aws_elasticache_cluster.this.cache_nodes.0.port
}