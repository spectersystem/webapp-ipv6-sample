# develop
module "vpc" {
  source = "../../modules/vpc"

  env = var.env

  # VPC
  ipv4_cidr = var.ipv4_cidr

  # Subnet
  subnets = var.subnets

}
