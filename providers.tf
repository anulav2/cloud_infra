terraform {
  cloud {
    organization = "anulav2"

    workspaces {
      name = "cloud_infra"
    }
  }
}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


