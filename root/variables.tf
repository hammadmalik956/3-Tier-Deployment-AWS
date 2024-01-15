variable "vpc" {
  type = map(any)
  default = {
    region          = {}
    project_name    = {}
    vpc_cidr        = {}
    pub_cidr_blocks = {}
    pri_cidr_blocks = {}
    sg_rules        = {}
    create_nat      = { default = true }
  }
}

variable "security_group" {
  type = map(any)
  default = {
    sg_rules = {}
  }
}
variable "alb" {
  type = map(any)
  default = {
    enabled             = {}
    interval            = {}
    path                = {}
    timeout             = {}
    matcher             = {}
    healthy_threshold   = {}
    unhealthy_threshold = {}
  }
}
variable "instance" {
  type = map(any)
  default = {
    ami = {}
    cpu = {}

  }
}
variable "asg_capacities" {
  type = map(any)
  default = {
    max_cap     = 3
    min_cap     = 1
    desired_cap = 2

  }
}
variable "scale_up_policy" {
  type = list(object({
    metric_interval_lower_bound = number
    metric_interval_upper_bound = optional(number)
    scaling_adjustment          = number
  }))
  default = [
    {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 15
      scaling_adjustment          = 1
    },
    {
      metric_interval_lower_bound = 15
      metric_interval_upper_bound = 25
      scaling_adjustment          = 1
    },
    {
      metric_interval_lower_bound = 25
      scaling_adjustment          = 1
    },
  ]
}

variable "scale_down_policy" {
  type = list(object({
    metric_interval_lower_bound = optional(number)
    metric_interval_upper_bound = optional(number)
    scaling_adjustment          = number
  }))
  default = [
    {
      metric_interval_upper_bound = -25
      scaling_adjustment          = -1
    },
    {
      metric_interval_lower_bound = -25
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  ]
}

variable "DB" {
  type = object({
    password_length   = number
    pass_numeric_flag = bool
    pass_upper_flag   = bool
    pass_special_flag = bool
    pass_min_upper    = number
    pass_min_special  = number

    secret_recovery_days  = number
    secret_overwrite_flag = bool

    pass_iam_role          = string
    pass_iam_policy        = string
    pass_policy_attachment = string
  })
}

variable "tags" {
  type = object({
    vpc_tags    = object({ Name = string, Age = string })
    subnet_tags = object({ Name = string, Age = string })
  })
  default = {
      vpc_tags = {
        Name = "hammad",
        Age  = "19"
      }
      subnet_tags = {
        Name = "hammad",
        Age  = "19"
      }
    }
    
  
}
