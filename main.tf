provider "aws" {
  region = "ap-south-1"
  //access_key = ""
  //secret_key = ""
}

variable "vpc_subnet_cidr_block" {
  description = "vpc subnet cidr block"
  //default = "10.0.10.0/24" // will takes effect if there is no value defined. 
  //type = list(string) //restrict admin not pass like arrary etc.,
  type = list(object({
        cidr_block = string
        name = string
  }))
}

//variable "environment" {
//description = "development environment"
//}

resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_subnet_cidr_block[0].cidr_block // "10.0.0.0/16"
  tags = {
    Name: var.vpc_subnet_cidr_block[0].name // "Development"
  }
}

resource "aws_subnet" "dev_subnet_1" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block =  var.vpc_subnet_cidr_block[1].cidr_block // "10.0.10.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name: var.vpc_subnet_cidr_block[1].name
  //vpc_env: "Dev"
  }
}

data "aws_vpc" "exsisting_vpc" {
  default = true
}

resource "aws_subnet" "dev_subnet_2" {
  vpc_id = data.aws_vpc.exsisting_vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "ap-south-1b"
  tags = {
    Name: "Development-Subnet-2"
  }
}

output "dev_vpc_id" {
  value  = aws_vpc.dev_vpc.id
}

output "dev_subnet_id" {
  value  = aws_subnet.dev_subnet_1.id
}
