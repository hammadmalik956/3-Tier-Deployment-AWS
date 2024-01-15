vpc = {
  config = {
    project_name    = "hammad-Infra"
    region          = "us-east-1"
    vpc_cidr        = "10.0.0.0/16"
    pub_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    pri_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
    create_nat      = true
  }
}
security_group = {
  config = {
    sg_rules = {
      0 : {
        name  = "Alb-sg"
        ports = [80, 443, 22]
      }
      1 : {
        name  = "Client-sg"
        ports = [22, 3001]
      }
      2 : {
        name  = "db-sg"
        ports = [27017, 22]
      }
    }
  }
}

alb = {
  config = {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

instance = {
  config = {
    ami = "ami-0fc5d935ebf8bc3bc"
    cpu = "t2.micro"
  }
}
asg_capacities = {
  config = {
    max_cap     = 5
    min_cap     = 2
    desired_cap = 2
  }
}
scale_up_policy = [
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

scale_down_policy = [
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

DB = {
  password_length   = 15
  pass_numeric_flag = true
  pass_upper_flag   = true
  pass_special_flag = true
  pass_min_upper    = 2
  pass_min_special  = 2

  secret_recovery_days  = 0
  secret_overwrite_flag = true

  pass_iam_role          = "MyIAMRoleMongo"
  pass_iam_policy        = "SecretManagerAccessPolicyMongo"
  pass_policy_attachment = "SecretManagerAccessAttachment"

}

tags = {
  vpc_tags = {
    Name = "Hammad"
    Age  = "19"

  },
  subnet_tags = {
    Name = "Bilal"
    Age  = "91"
  }

}