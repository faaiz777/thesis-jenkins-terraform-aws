# terraform {
#   #############################################################
#   ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
#   ## YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
#   ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
#   #############################################################
#   backend "s3" {
#     bucket         = "faaiz-terraformstatebucket" # REPLACE WITH YOUR BUCKET NAME
#     key            = "global/s3/terraform.tfstate"
#     region         = "eu-central-1"
#     dynamodb_table = "state-lock-table"
#     encrypt        = true
#   }
# }

# Configure the AWS Provider
provider "aws" {
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
  #token = var.token
}


module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr_block    = var.vpc_cidr_block 
  env_prefix        = var.env_prefix
}

module "myapp-subnet" {
  source            = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  env_prefix        = var.env_prefix
  vpc_id            = module.vpc.vpc
  vpc_cidr_block    = var.vpc_cidr_block
}


module "myapp-server" {
  source              = "./modules/webserver"
  env_prefix          = var.env_prefix
  vpc_id              = module.vpc.vpc
  #vpc_id              = aws_vpc.myapp_vpc.id
  my_ip               = var.my_ip
  key_name            = var.key_name
  public_key_location = var.public_key_location
  instance_type       = var.instance_type
  subnet_id           = module.myapp-subnet.subnet.id
  avail_zone          = var.avail_zone
}

module "terraform-backend" {
  source        = "./modules/remoteBackend"
  bucket_name   = var.bucket_name
  dynamoDB_name = var.dynamoDB_name
}
