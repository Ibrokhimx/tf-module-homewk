terraform {
  cloud {
    organization = "pitt412"

    workspaces {
      name = "module-hw"
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
  region = "us-east-1"
}

 variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
   
}
variable "subnets" {
    type = map(object({
      cidr_block = string
    }))
    default = {}
      
}

 module "vpc" {
    source   = "./module/vpc/"
    vpc_cidr = var.vpc_cidr #"10.0.0.0/16" 
 }
#  output "vpc_id" {
#     value = module.vpc.vpc_id
#  }
variable "availability_zone" {
    type = string
    default = ""
  
}
module "subnets" {
  source = "./module/subnet/"
  vpc_id = module.vpc.vpc_id
  subnets = {
    my_first_module_subnet = {
        cidr_block = "10.0.1.0/24"
        availability_zone = "us-east-1c"
    }
    my_second_module_subnet = {
        cidr_block = "10.0.2.0/24"
        availability_zone = "us-east-1a"
    }
    my_third_module_subnet = {
        cidr_block = "10.0.3.0/24"
        availability_zone = "us-east-1b"
    }
  }
}