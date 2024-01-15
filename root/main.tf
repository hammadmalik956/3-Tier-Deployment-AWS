
module "vpc" {
  source = "../modules/vpc"
  vpc    = var.vpc


}


module "security-group" {
  source         = "../modules/security-group"
  vpc_id         = module.vpc.vpc_outputs.vpc_id
  vpc_cidr       = var.vpc.config.vpc_cidr
  security_group = var.security_group

}

# # creating Key for instances
module "key" {
  source = "../modules/key"
}
module "database" {
  source           = "../modules/database"
  project_name     = var.vpc.config.project_name
  key_name         = module.key.key_name
  db_sg_id         = module.security-group.sg_outputs.db_sg_id
  pri_sub_database = module.vpc.vpc_outputs.pri_subnet_ids[2]
  instance         = var.instance
  DB               = var.DB
}
module "backend" {
  source             = "../modules/backend"
  project_name       = var.vpc.config.project_name
  key_name           = module.key.key_name
  db_private_Ip      = module.database.db_private_Ip
  client_sg_id       = module.security-group.sg_outputs.client_sg_id
  pri_sub_backend    = module.vpc.vpc_outputs.pri_subnet_ids[1]
  IAMInstanceprofile = module.database.IAMInstanceprofile
  instance           = var.instance
}


# Creating Application Load balancer
module "alb" {
  source         = "../modules/alb"
  project_name   = module.vpc.vpc_outputs.project_name
  alb_sg_id      = module.security-group.sg_outputs.alb_sg_id
  pub_subnet_ids = module.vpc.vpc_outputs.pub_subnet_ids
  vpc_id         = module.vpc.vpc_outputs.vpc_id
  alb            = var.alb

}


module "asg" {
  source            = "../modules/asg"
  project_name      = module.vpc.vpc_outputs.project_name
  client_private_Ip = module.backend.client_private_Ip
  key_name          = module.key.key_name
  alb_sg_id         = module.security-group.sg_outputs.alb_sg_id
  pub_subnet_ids    = module.vpc.vpc_outputs.pub_subnet_ids
  tg_arn            = module.alb.tg_arn
  scale_up_policy   = var.scale_up_policy
  scale_down_policy = var.scale_down_policy
  instance          = var.instance
  asg_capacities    = var.asg_capacities

}

module "route53" {
  source       = "../modules/route53"
  alb_zone_id  = module.alb.alb_zone_id
  alb_dns_name = module.alb.alb_dns_name

}
