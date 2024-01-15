

output "vpc_outputs" {
  value = {
    region          = var.vpc.config.region
    project_name    = var.vpc.config.project_name
    vpc_id          = aws_vpc.vpc.id
    pub_subnet_ids = [for i in range(length(var.vpc.config.pub_cidr_blocks)) : aws_subnet.pub_subnets[i].id]
    pri_subnet_ids =  [for i in range(length(var.vpc.config.pri_cidr_blocks)) : aws_subnet.pri_subnets[i].id]
    igw_id          = aws_internet_gateway.internet_gateway
  
  }
}
