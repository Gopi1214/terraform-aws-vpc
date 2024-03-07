terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.38.0"
    }
  }
  backend "s3" {
    bucket = "terraform-gmd-tfstate"
    key    = "vpc_test"
    region= "us-east-1"
    dynamodb_table = "terraform-gmd-locking"
  }
}

provider "aws" {
  region= "us-east-1"
}