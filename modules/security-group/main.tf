resource "aws_security_group" "my_sg" {
  count       = length(var.security_group.config.sg_rules)
  name        = var.security_group.config.sg_rules[count.index].name
  description = "Security group for ${var.security_group.config.sg_rules[count.index].name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group.config.sg_rules[count.index].ports
    content {
      description = "access"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = count.index == 0 ? ["0.0.0.0/0"] : [var.vpc_cidr]
      
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-${var.security_group.config.sg_rules[count.index].name}"
  }
}
