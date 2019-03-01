terraform {
  backend "s3" {

  }
}

provider "aws" {
  region  = "eu-central-1"
  version = "~> 1.19"
}