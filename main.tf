provider "aws" {
  region = "ap-south-1"
  //access_key = ""
  //secret_key = ""
}

variable "vpc_cidr_block" {}
  //description = "vpc subnet cidr block"
  //default = "10.0.10.0/24" // will takes effect if there is no value defined. 
  //type = list(string) //restrict admin not pass like arrary etc.,
  //type = list(object({
  //    cidr_block = string
  //    name = string
  //}))
//}

variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}


//variable "environment" {
//description = "development environment"
//}

resource "aws_vpc" "myapp_vpc" { //"dev_vpc"
  cidr_block = var.vpc_cidr_block //var.vpc_subnet_cidr_block[0].cidr_block // "10.0.0.0/16"
  tags = {
    Name: "${var.env_prefix}-vpc" // ${}->to define a variable inside the "Quote" // var.vpc_subnet_cidr_block[0].name // "Development"
  }
}

resource "aws_subnet" "myapp_subnet_1" { //"dev_subnet_1"
  vpc_id = aws_vpc.myapp_vpc.id
  cidr_block = var.subnet_cidr_block // var.vpc_subnet_cidr_block[1].cidr_block // "10.0.10.0/24"
  availability_zone = var.avail_zone // "ap-south-1a"
  tags = {
    Name: "${var.env_prefix}-subet-1" //var.vpc_subnet_cidr_block[1].name
  //vpc_env: "Dev"
  }
}

//data "aws_vpc" "exsisting_vpc" {
//default = true
//}

//resource "aws_subnet" "dev_subnet_2" {
//vpc_id = data.aws_vpc.exsisting_vpc.id
//cidr_block = "172.31.48.0/20"
//availability_zone = "ap-south-1b"
//tags = {
//Name: "Development-Subnet-2"
//}
//}

//output "dev_vpc_id" {
//value  = aws_vpc.dev_vpc.id
//}

//output "dev_subnet_id" {
//value  = aws_subnet.dev_subnet_1.id
//}

/*resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp_vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
      Name: "${var.env_prefix}-rtb"
    }
}*/

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp_vpc.id
      tags = {
      Name: "${var.env_prefix}-igw"
    }
}

/*resource "aws_route_table_association" "assoc-rtb-Subnet" {
      subnet_id = aws_subnet.myapp_subnet_1.id
      route_table_id = aws_route_table.myapp-route-table.id
}*/


resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
      Name: "${var.env_prefix}-main-rtb"
    }
}


resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp_vpc.id

    ingress {       //inbound 
        from_port = 22
        to_port = 22   //opening only one port 22 or we can give range here
        protocol = "tcp"
        cidr_blocks = [var.my_ip] // ["117.194.132.9/32"] //define only my local ip /32 means one IP

    }

    ingress {       
        from_port = 8080
        to_port = 8080   
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 

    }

    egress {       
        from_port = 0
        to_port = 0   
        protocol = "-1" //to allow any prtocol -> -1
        cidr_blocks = ["0.0.0.0/0"] 
        prefix_list_ids = [] //allow access to vpc endpoints ??
    }

    tags = {
      Name: "${var.env_prefix}-sg" 
    }
}



