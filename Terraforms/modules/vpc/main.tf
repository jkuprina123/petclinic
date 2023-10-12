# Ievada eksistējošā VPC konfigurāciju
variable "vpc_id" {
  type        = string
  description = "Eksistējošā VPC ID"
  #default="vpc-0e2edd2eaeabb5a70"
}

variable "cidr_block" {
  type        = string
  description = "New CIDR block for new subnet"
  #default="172.31.64.0/20"
}

variable "availability_zone" {
  type        = string
  description = "Aviability zone"
}

# Iegūst eksistējošo VPC konfigurāciju
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Atgriež eksistējošā VPC konfigurāciju
#output "vpc_id" {
# value = var.vpc_id
#}

#output "cidr_block"{
# value =var.cidr_block
#}

output "public_subnet_id" {
  value       = aws_subnet.subnet.id
  description = "Present subnet ID"
}

output "default_security_group_id" {
  value       = aws_security_group.default.id
  description = "Present Security group ID"
}


# Izveido publisko subnet konfigurāciju
resource "aws_subnet" "subnet" {
  vpc_id            = data.aws_vpc.selected.id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name  = "Public Subnet "
    Owner = "Deniss"
  }
}

# Private subnet
resource "aws_subnet" "private_subnets" {

  vpc_id            = data.aws_vpc.selected.id
  cidr_block        = "172.31.65.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name  = "Private Subnet 1"
    Owner = "Deniss"
  }
}

# Izveido default security group
resource "aws_security_group" "default" {
  name_prefix = "default_sg_"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Default Security Group"
    Owner = "Deniss"
  }
}