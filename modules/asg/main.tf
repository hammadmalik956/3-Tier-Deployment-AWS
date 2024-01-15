resource "aws_launch_template" "lt_name" {
  name          = "${terraform.workspace}-${var.project_name}-tpl"
  image_id      = var.instance.config.ami
  instance_type = var.instance.config.cpu
  key_name      = var.key_name
  user_data     = base64encode(templatefile("../modules/asg/config.sh",{ 
    private_Ip = var.client_private_Ip} ))


  vpc_security_group_ids = [var.alb_sg_id.value]
  tags = {
    Name = "${terraform.workspace}-${var.project_name}-tpl"
  }
}

resource "aws_autoscaling_group" "asg_name" {

  name                      = "${var.project_name}-asg"
  max_size                  = var.asg_capacities.config.max_cap
  min_size                  = var.asg_capacities.config.min_cap
  desired_capacity          = var.asg_capacities.config.desired_cap
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type #"ELB" or default EC2
  vpc_zone_identifier = [var.pub_subnet_ids[0],var.pub_subnet_ids[1]]
  target_group_arns   = [var.tg_arn] #var.target_group_arns

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.lt_name.id
    version = aws_launch_template.lt_name.latest_version 
  }
}

# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${terraform.workspace}-${var.project_name}-asg-scale-up"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg_name.name
  policy_type            = "StepScaling"


  dynamic "step_adjustment" {
    for_each = var.scale_up_policy
    content {
      metric_interval_lower_bound = step_adjustment.value.metric_interval_lower_bound
      metric_interval_upper_bound = step_adjustment.value.metric_interval_upper_bound
      scaling_adjustment          = step_adjustment.value.scaling_adjustment
    }
  }
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${terraform.workspace}-${var.project_name}-asg-scale-down"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg_name.name
  policy_type            = "StepScaling"
 
  dynamic "step_adjustment" {
    for_each = var.scale_down_policy
    content {
      metric_interval_lower_bound = step_adjustment.value.metric_interval_lower_bound
      metric_interval_upper_bound = step_adjustment.value.metric_interval_upper_bound
      scaling_adjustment          = step_adjustment.value.scaling_adjustment
    }
  }
}

# scale up alarm
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${terraform.workspace}-${var.project_name}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_name.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${terraform.workspace}-${var.project_name}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_name.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}
