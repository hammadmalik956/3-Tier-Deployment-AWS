variable key_name {}
variable client_sg_id {}
variable pri_sub_backend {}

variable db_private_Ip {}
variable "project_name" {}
variable "instance" {
  type = map(any)
  default={
    ami ={}
    cpu ={}

  }
}

variable  IAMInstanceprofile {}