resource "aws_sns_topic" "prod_alerts" {
  name = "${var.project_name}-${var.environment}-alerts"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-asg-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Triggers when average EC2 CPU usage is above 75%"
  alarm_actions       = [aws_sns_topic.prod_alerts.arn]

  dimensions = {
    AutoScalingGroupName = module.compute.autoscaling_group_name
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "Triggers when the ALB target group has unhealthy targets"
  alarm_actions       = [aws_sns_topic.prod_alerts.arn]

  dimensions = {
    TargetGroup = module.alb.target_group_arn
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}