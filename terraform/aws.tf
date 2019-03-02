
module "es-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.es_vpc_name}"
  cidr = "${var.es_vpc_cidr_block}"

  azs             = "${var.es_vpc_azs}"
  private_subnets = "${var.es_vpc_private_subnets}"
  public_subnets  = "${var.es_vpc_public_subnets}"

  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true

  tags = {
    ElastiSearch = true
  }
}

resource "aws_iam_service_linked_role" "es-iam-service-linked-role" {
  aws_service_name = "es.amazonaws.com"
  description      = "AWSServiceRoleForAmazonElasticsearchService Service-Linked Role"
}

module "es-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "es-security-group"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "${module.es-vpc.vpc_id}"

  # Every resource in the created VPC should be able to access the cluster
  ingress_cidr_blocks = ["${var.es_vpc_cidr_block}"]
  ingress_rules       = ["${var.es_sg_ingress_rules}"]

  # ElasticSearch cluster should not have limitation on which addresses it can access
  egress_cidr_blocks = ["${var.es_sg_egress_cidr_blocks}"]
  egress_rules       = ["${var.es_sg_egress_rules}"]
}

resource "aws_cloudwatch_log_group" "es-index-slow-logs-group" {
  name        = "${var.cloudwatch_es_index_slow_logs_group_name}"
}

resource "aws_cloudwatch_log_group" "es-search-slow-logs-group" {
  name        = "${var.cloudwatch_es_search_slow_logs_group_name}"
}

resource "aws_cloudwatch_log_group" "es-application-logs-group" {
  name        = "${var.cloudwatch_es_application_logs_group_name}"
}

resource "aws_cloudwatch_log_resource_policy" "es-index-slow-logs-group-policy" {
  policy_name = "${var.cloudwatch_es_index_slow_logs_group_name}-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_cloudwatch_log_resource_policy" "es-search-slow-logs-group-policy" {
  policy_name = "${var.cloudwatch_es_search_slow_logs_group_name}-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_cloudwatch_log_resource_policy" "es-application-logs-group-policy" {
  policy_name = "${var.cloudwatch_es_application_logs_group_name}-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_elasticsearch_domain" "es-cluster" {
  domain_name           = "${var.es_domain_name}"
  elasticsearch_version = "${var.es_version}"

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG

  ebs_options {
    ebs_enabled = "${var.es_ebs_enabled}"
    volume_size = "${var.es_ebs_volume_size}"
  }

  encrypt_at_rest {
    enabled = "${var.es_encryption_at_rest}"
  }

  cluster_config {
    instance_type = "${var.es_instance_type}"
    instance_count = "${var.es_instance_count}"
    zone_awareness_enabled = "${var.es_zone_awareness_enabled}"
  }
  
  vpc_options {
    security_group_ids = ["${module.es-sg.this_security_group_id}"]
    subnet_ids         = ["${module.es-vpc.public_subnets}"]
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.es-index-slow-logs-group.arn}"
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.es-search-slow-logs-group.arn}"
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.es-application-logs-group.arn}"
  }

  tags = {
    Domain = "TestDomain"
  }

  depends_on = ["aws_iam_service_linked_role.es-iam-service-linked-role"]
}
