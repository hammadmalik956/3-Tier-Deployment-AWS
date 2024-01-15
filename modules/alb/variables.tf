variable project_name {}
variable alb_sg_id {}
variable pub_subnet_ids {}
variable vpc_id {}
variable aws_acm_arn {default = "arn:aws:acm:us-east-1:489994096722:certificate/96a3296b-952c-4da1-b986-9298115e0f1c"}
variable "alb" {
  type = map(any)
  default ={
    enabled             = {}
    interval            = {}
    path                = {}
    timeout             = {}
    matcher             = {}
    healthy_threshold   = {}
    unhealthy_threshold = {}
  }
}