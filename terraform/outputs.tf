output "es_domain_id" {
  value = "${aws_elasticsearch_domain.es-cluster.domain_id}"
}
output "es_domain_name" {
  value = "${aws_elasticsearch_domain.es-cluster.domain_name}"
}

output "es_endpoint" {
  value = "${aws_elasticsearch_domain.es-cluster.endpoint}"
}