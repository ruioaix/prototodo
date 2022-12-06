terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0.0"
    }
  }
  required_version = ">= 1.0.0, < 2.0.0"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      ManagedBy   = "terraform"
      BelongTo = var.project_name
    }
  }
}
