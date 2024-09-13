terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}

provider "aws" {
  # Necessário criar o terraform.tfvars
  profile = var.profile
  region  = var.default-region

}