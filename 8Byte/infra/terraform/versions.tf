terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  cloud {
    organization = "your-hcp-org"
    workspaces {
      name = "8byte-dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}
