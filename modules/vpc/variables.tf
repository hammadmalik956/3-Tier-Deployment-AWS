
variable "vpc" {
  type = map 
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

variable "tags" {
  type = object({
    vpc_tags    = object({ Name = string, Age = string })

  })
  default = {
      vpc_tags = {
        Name = "hammad",
        Age  = "19"
      }
    }
    
  
}