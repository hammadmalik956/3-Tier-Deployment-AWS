resource "random_password" "db_password" {
  length  = var.DB.password_length 
  numeric = var.DB.pass_numeric_flag
  upper = var.DB.pass_upper_flag
  min_upper = var.DB.pass_min_upper
  min_special = var.DB.pass_min_special
  special          = var.DB.pass_special_flag
}


resource "aws_secretsmanager_secret" "databasePasswordmongo" {
  name = "MongoDBPass"
  recovery_window_in_days = var.DB.secret_recovery_days
  force_overwrite_replica_secret = var.DB.secret_overwrite_flag
  tags = {
    Name = "${terraform.workspace}-MongoDBPass"  }
}

resource "aws_secretsmanager_secret_version" "databasePasswordmongoValue" {
  secret_id = aws_secretsmanager_secret.databasePasswordmongo.id
  secret_string = <<EOF
   {
    "password": "${random_password.db_password.result}"
   }
EOF
}


resource "aws_iam_role" "MyIAMRole" {
  name = var.DB.pass_iam_role
  assume_role_policy = file("${path.module}/iamrole.json")

  tags = {
    Name = "${terraform.workspace}-DBIamRole"  
    }
  }


resource "aws_iam_policy" "SecretManagerAccessPolicy" {
  name        = var.DB.pass_iam_policy
  description = "A policy to access my password using secretsmanageraccess policy"

  policy = file("${path.module}/iampolicy.json")
}

resource "aws_iam_policy_attachment" "SecretManagerAccessAttachment" {
  name        = var.DB.pass_policy_attachment
  policy_arn = aws_iam_policy.SecretManagerAccessPolicy.arn
  roles      = [aws_iam_role.MyIAMRole.name]
}


resource "aws_iam_instance_profile" "IAMInstanceprofile" {
  name = "${terraform.workspace}-IamProfile"
  role = aws_iam_role.MyIAMRole.name
}



resource "aws_instance" "database" {

    ami = var.instance.config.ami
    instance_type = var.instance.config.cpu
    key_name = var.key_name
    vpc_security_group_ids = [var.db_sg_id.value]
    subnet_id = var.pri_sub_database
    iam_instance_profile = aws_iam_instance_profile.IAMInstanceprofile.name
    user_data     = file("../modules/database/config.sh")
    tags   = {
        Name = "${terraform.workspace}-${var.project_name}-database"
}
}