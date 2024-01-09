# Variable
locals{
  subnet_index = [for k, v in var.subnets : k]
}

# VPC
resource "aws_vpc" "webapp_vpc" {
  cidr_block                       = var.ipv4_cidr
  assign_generated_ipv6_cidr_block = true

  enable_dns_hostnames             = true
  tags = {
    Name = "${var.env}-webapp-vpc"
  }
}

# Subnet
resource "aws_subnet" "main" {
  for_each = {for k, v in var.subnets: k => v }

  availability_zone               = each.value.az
  vpc_id                          = aws_vpc.webapp_vpc.id
  assign_ipv6_address_on_creation = true
  ipv6_native                     = true
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.webapp_vpc.ipv6_cidr_block, 8, index( local.subnet_index, each.key))}"
  enable_resource_name_dns_aaaa_record_on_launch = true

  tags = {
    Name = "${var.env}-webapp-subnet-${each.key}"
  }
}