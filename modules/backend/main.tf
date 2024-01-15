resource "aws_instance" "backend" {

    ami = var.instance.config.ami
    instance_type = var.instance.config.cpu
    key_name = var.key_name
    vpc_security_group_ids = [var.client_sg_id.value]
    subnet_id = var.pri_sub_backend
    user_data     = base64encode(templatefile("../modules/backend/config.sh",{ 
    private_Ip = var.db_private_Ip,
    DATABASE_PASSWORD = ""} ))
    iam_instance_profile = var.IAMInstanceprofile
    tags   = {
    Name = "${terraform.workspace}-${var.project_name}-backend"
  }
}