 variable vpc_id {}
variable vpc_cidr {}
variable "security_group" {
  type = map 
  default = {
    sg_rules        = {}
  }
}
