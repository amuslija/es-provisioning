variable "es_domain_name" {
  description = "ElasticSearch Domain Name"
}

variable "es_ebs_enabled" {
  description = "Enable ElasticSearch EBS storage"
}

variable "es_ebs_volume_size" {
  description = "Volume size of the ElasticSearch EBS storage"
}

variable "es_encryption_at_rest" {
  description = "Should ElasticSearch have encryption at rest enabled"
}

variable "es_instance_type" {
  description = "Instance type which will be used for the ElasticSearch cluster"
}

variable "es_instance_count" {
  description = "Number of ElasticSearch instances in the cluster"
}

variable "es_zone_awareness_enabled" {
  description = "Enable zone awareness, ensuring that instances are distributed over different AZs"
}

variable "es_automated_snapshot_start_hour" {
  description = "When to create snapshot of existing ElasticSearch indices"
}

variable "es_version" {
  description = "ElasticSearch cluster version"
}

variable "cloudwatch_es_index_slow_logs_group_name" {
  description = "CloudWatch group name for ElasticSearch INDEX_SLOW_LOGS"
}

variable "cloudwatch_es_search_slow_logs_group_name" {
  description = "CloudWatch group name for ElasticSearch SEARCH_SLOW_LOGS"
}

variable "cloudwatch_es_application_logs_group_name" {
  description = "CloudWatch group name for ElasticSearch ES_APPLICATION_LOGS"
}

variable "es_vpc_name" {
  description = "Name of the VPC for the ElasticSearch cluster"
}

variable "es_vpc_cidr_block" {
  description = "CIDR block fo the ElasticSearch VPC"
}

variable "es_vpc_azs" {
  description = "Availability zones of the ElasticSearch VPC"
  type = "list"
}

variable "es_vpc_private_subnets" {
  description = "List of ElasticSearch VPC private subnets"
  type = "list"
}

variable "es_vpc_public_subnets" {
  description = "List of ElasticSearch VPC public subnets"
  type = "list"
}

variable "es_sg_ingress_cidr_blocks" {
  description = "CIDR block of addresses that can access the ElasticSearch cluster"
  type = "list"
}

variable "es_sg_ingress_rules" {
  description = "Protocols/rules which are available for the ElasticSearch cluster"
  type = "list"
}


variable "es_sg_egress_cidr_blocks" {
  description = "CIDR block of addresses which can be accessed ElasticSearch cluster"
  type = "list"
}

variable "es_sg_egress_rules" {
  description = "Protocols/rules which the ElasticSearch cluster can use"
  type = "list"
}