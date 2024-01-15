# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.config.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    
    Name = "${terraform.workspace}-${var.vpc.config.project_name}-vpc"
  }
#    tags ={
#     for key, value in var.tags:
#     key => key == "Name" ? "${value}-${terraform.workspace}" : value
# }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${terraform.workspace}-${var.vpc.config.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnets
resource "aws_subnet" "pub_subnets" {
  count = length(var.vpc.config.pub_cidr_blocks)

  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = element(var.vpc.config.pub_cidr_blocks,count.index)
  availability_zone        = data.aws_availability_zones.available_zones.names[count.index % 2]
  map_public_ip_on_launch  = true

  tags      = {
   Name = "${terraform.workspace}-pub-sub-${count.index + 1}"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "${terraform.workspace}-Public-RT"
  }
}

# associate public subnet pub-sub-1a to public route table
resource "aws_route_table_association" "pub-sub-1a_route_table_association" {
  count = length(var.vpc.config.pub_cidr_blocks)

  subnet_id           = element(aws_subnet.pub_subnets,count.index).id
  route_table_id      = aws_route_table.public_route_table.id
}

# create private app subnets
resource "aws_subnet" "pri_subnets" {
  count = length(var.vpc.config.pri_cidr_blocks)

  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = element(var.vpc.config.pri_cidr_blocks,count.index)
  availability_zone        = data.aws_availability_zones.available_zones.names[count.index % 2]
  map_public_ip_on_launch  = false

  tags      = {
   Name = "${terraform.workspace}-pri-sub-${count.index + 1}"
  }
}





# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet pub-sub-1-a
resource "aws_eip" "eip-nat-a" {
  domain    = "vpc"

  tags   = {
    Name = "${terraform.workspace}-eip-nat-a"
  }
}


# create nat gateway in public subnet pub-sub-1a
resource "aws_nat_gateway" "nat-a" {
  
  count          = var.vpc.config.create_nat ? 1 : 0
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = aws_subnet.pub_subnets[0].id

  tags   = {
    Name = "${terraform.workspace}-nat-a"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.internet_gateway]
}

# create private route table Pri-RT-A and add route through NAT-GW-A
resource "aws_route_table" "pri-rt-a" {
  count          = var.vpc.config.create_nat ? 1 : 0
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-a[0].id
  }

  tags   = {
    Name = "${terraform.workspace}-Pri-rt-a"
  }
}

# associate private subnet pri-sub-3-a with private route table Pri-RT-A
resource "aws_route_table_association" "pri_sub_3a_with_pri_rt_a" {
  
  count = var.vpc.config.create_nat ? length(aws_subnet.pri_subnets) - 1 : 0

  subnet_id      = aws_subnet.pri_subnets[count.index].id
  route_table_id = aws_route_table.pri-rt-a[0].id
}




# create private route table Pri-rt-db and add route through nat-a
resource "aws_route_table" "pri-rt-db" {
  count          = var.vpc.config.create_nat ? 1 : 0
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-a[0].id
  }

  tags   = {
    Name = "${terraform.workspace}-pri-rt-db"
  }
}

# associate private subnet pri-sub-5a with private route Pri-rt-db
resource "aws_route_table_association" "pri-sub-5a-with-pri-rt-b" {
   count          = var.vpc.config.create_nat ? 1 : 0
  subnet_id         = aws_subnet.pri_subnets[length(aws_subnet.pri_subnets)-1].id
  route_table_id    = aws_route_table.pri-rt-db[0].id
}

