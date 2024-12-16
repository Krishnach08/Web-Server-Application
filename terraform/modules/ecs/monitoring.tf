# Define a CloudWatch alarm for high CPU usage
resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  alarm_name          = "ecs-high-cpu"   # Name of the alarm
  comparison_operator = "GreaterThanThreshold" # Trigger the alarm if value exceeds the threshold
  evaluation_periods  = 2                # Number of periods to evaluate the metric
  metric_name         = "CPUUtilization" # Metric to monitor
  namespace           = "AWS/ECS"        # ECS-specific namespace
  period              = 60               # Evaluation period in seconds
  statistic           = "Average"        # Use the average value of the metric
  threshold           = 80               # CPU usage threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_out.arn] # Trigger scale-out policy
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name # ECS cluster name
    ServiceName = aws_ecs_service.main.name # ECS service name
  }
}

# Define a CloudWatch alarm for high memory usage
resource "aws_cloudwatch_metric_alarm" "ecs_high_memory" {
  alarm_name          = "ecs-high-memory" # Name of the alarm
  comparison_operator = "GreaterThanThreshold" # Trigger the alarm if value exceeds the threshold
  evaluation_periods  = 2                # Number of periods to evaluate the metric
  metric_name         = "MemoryUtilization" # Metric to monitor
  namespace           = "AWS/ECS"        # ECS-specific namespace
  period              = 60               # Evaluation period in seconds
  statistic           = "Average"        # Use the average value of the metric
  threshold           = 80               # Memory usage threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_out.arn] # Trigger scale-out policy
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name # ECS cluster name
    ServiceName = aws_ecs_service.main.name # ECS service name
  }
}
