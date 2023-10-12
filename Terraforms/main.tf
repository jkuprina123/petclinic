terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.20.1"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
  profile = "default"

}

variable "region" {
  default     = "us-west-2"
  type        = string
  description = "the Region of deploy"
}

variable "vpc_id" {
  default     = "vpc-0e2edd2eaeabb5a70"
  type        = string
  description = "Default VPC id"

}

variable "cidr_block" {
  default     = "172.31.64.0/24"
  type        = string
  description = "Default CIDR BLOCK"

}



# Izveido VPC konfigurāciju
module "vpc" {
  source = "./modules/vpc"

  # Ievada eksistējošā VPC ID un subnet ID
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = "${var.region}a"
}

# Izveido EC2 instanci
resource "aws_instance" "example_instance" {
  ami                         = "ami-03f65b8614a860c29"
  instance_type               = "t2.large"
  vpc_security_group_ids      = [module.vpc.default_security_group_id]
  availability_zone           = "${var.region}a"
  subnet_id                   = module.vpc.public_subnet_id
  key_name                    = "dontforgetapp-dev-key"
  associate_public_ip_address = true

  tags = {
    Name  = "For-Test-From-Terraform"
    Owner = "Deniss"
  }
}