# ElasticSearch Terraform Provisioning

## Description
This repo contains a simple provisioning plan for an ElasticSearch cluster. The provisioning plan will create:

1. VPC with a Public and Private Subnet
1. Security groups for the ElasticSearch cluster
1. CloudWatch groups for ElasticSearch logs
1. ElasticSearch Domain/cluster

## Usage

These plans use AWS S3 as a backend for storing infrastructure state. From the `terraform` directory, initialize the Terraform plans via

```bash
  terraform init \
    -backend-config="bucket=<bucket_name>" \
    -key="key=<key>" \
    -region="region=<region>>
```

Afterwards, check what resources will be created using:

```bash
terraform plan
```

If everything is okay, execute the plans via the command

```bash
terraform apply -auto-approve
```

## Improvements

1. Create endpoint for Kibana (Route53)
1. Set up alerting for CloudWatch logs
