packer {
    ##this is where we tell packer we are using aws
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


#this is where we tell packer which AMI we are using as a base.
#where to save the AMI after its built.
source "amazon-ebs" "image-instance" {
  ami_name = "PackerEC2-${local.timestamp}"

  # source_ami = "ami-013a129d325529d4d"  
  #instead of hardcoding ami value, we use filters.
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.*.1-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
 

  instance_type = "t2.micro"
  region = "eu-central-1"
  ssh_username = "ec2-user"
}


#Everything in between.
# what to install
#configure
#files to copy
#steps executed in the order that provisioners are listed.

build {
  sources = [
    "source.amazon-ebs.image-instance"
  ]
    
  provisioner "file" {
    source = "../sample-nodeApp.zip"
    destination = "/home/ec2-user/sample-nodeApp.zip"
  }

  provisioner "file" {
    source = "./cocktails.service"
    destination = "/tmp/cocktails.service"
  }

  provisioner "shell" {
    script = "./app.sh"
  }
}
