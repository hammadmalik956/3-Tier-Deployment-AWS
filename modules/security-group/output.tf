output "sg_outputs" {
  value = {
    alb_sg_id          = {value = aws_security_group.my_sg[0].id}
    client_sg_id       = {value = aws_security_group.my_sg[1].id}
    db_sg_id          =  {value = aws_security_group.my_sg[2].id}
  }
}