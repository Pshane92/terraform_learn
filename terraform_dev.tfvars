//subnet_cidr_block = "10.0.40.0/24"
//vpc_cidr_block = "10.0.0.0/16"
//environment = "Development"
//vpc_subnet_cidr_block = ["10.0.0.0/16","10.0.40.0/24"]
vpc_subnet_cidr_block = [
    {cidr_block = "10.0.0.0/16", name = "dev_vpc"},
    {cidr_block = "10.0.40.0/24", name = "dev_subnet"}
]