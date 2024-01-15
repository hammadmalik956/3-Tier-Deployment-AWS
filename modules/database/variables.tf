variable key_name {}
variable db_sg_id {}
variable pri_sub_database {}
variable "project_name" {}
variable "instance" {
  type = map(any)
  default={
    ami ={}
    cpu ={}

  }
}

variable "DB"  {
    type = object({
        password_length = number
        pass_numeric_flag = bool
        pass_upper_flag = bool
        pass_special_flag = bool
        pass_min_upper= number
        pass_min_special = number

        secret_recovery_days = number
        secret_overwrite_flag = bool

        pass_iam_role = string
        pass_iam_policy = string
        pass_policy_attachment = string
    })
}