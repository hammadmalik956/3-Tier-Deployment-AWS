variable "project_name"{}
variable "key_name" {}
variable "alb_sg_id" {}
variable "instance" {
  type = map(any)
  default={
    ami ={}
    cpu ={}

  }
}
variable "asg_capacities" {
  type = map(any)
  default={
    max_cap =3
    min_cap =1
    desired_cap =2

  }
}

variable "asg_health_check_type" {
    default = "ELB"
}

variable "pub_subnet_ids" {}
variable "tg_arn" {}

variable client_private_Ip {}

variable "scale_up_policy" {
  type = list(object({
    metric_interval_lower_bound = number
    metric_interval_upper_bound = optional(number)
    scaling_adjustment          = number
  }))
#   default = [
#     {
#       metric_interval_lower_bound = 0
#       metric_interval_upper_bound = 15
#       scaling_adjustment          = 1
#     },
#     {
#       metric_interval_lower_bound = 15
#       metric_interval_upper_bound = 25
#       scaling_adjustment          = 1
#     },
#     {
#       metric_interval_lower_bound = 25
#       scaling_adjustment          = 1
#     },
#   ]
}

variable "scale_down_policy" {
  type = list(object({
    metric_interval_lower_bound = optional(number)
    metric_interval_upper_bound = optional(number)
    scaling_adjustment          = number
  }))
#   default = [
#     {
#       metric_interval_upper_bound = -25
#       scaling_adjustment          = -1
#     },
#     {
#       metric_interval_lower_bound = -25
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   ]
}