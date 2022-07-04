# Khai bao provider, xac thuc
# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
    required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "4.20.1"
      }
    }
}

provider "aws"{
    region = "ap-southeast-1" # Singapore region
}

# tao s3 bucket
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

module "my_s3" {
    source = "./modules/s3"
    bucket_name = "devops-05-2022-Minhhh"
    bucket_acl = "private"
    tags = {
        Env = "testing"
    }
}