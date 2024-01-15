# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${terraform.workspace}-${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id.value]
  subnets            = [var.pub_subnet_ids[0],var.pub_subnet_ids[1]]
  enable_deletion_protection = false

  tags   = {
    Name = "${terraform.workspace}-${var.project_name}-alb"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${terraform.workspace}-${var.project_name}-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = var.alb.config.enabled 
    interval            = var.alb.config.interval
    path                = var.alb.config.path
    timeout             = var.alb.config.timeout
    matcher             = var.alb.config.matcher
    healthy_threshold   = var.alb.config.healthy_threshold
    unhealthy_threshold = var.alb.config.unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = var.aws_acm_arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}