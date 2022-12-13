# Configure the AWS Provider
provider "aws" {
  region     = "eu-central-1"
  access_key = "Your_AWS_Access_key"
  secret_key = "Your_AWS_Secret_Key"
}


module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr_block    = var.vpc_cidr_block 
}

module "myapp-subnet" {
  source            = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  vpc_id            = module.vpc.vpc.id
  vpc_cidr_block    = var.vpc_cidr_block
}


module "myapp-server" {
  source              = "./modules/webserver"
  vpc_id              = module.vpc.vpc.id
  #vpc_id              = aws_vpc.myapp_vpc.id
  key_name            = var.key_name
  instance_type       = var.instance_type
  subnet_id           = module.myapp-subnet.subnet.id
  avail_zone          = var.avail_zone
}
