# Define the target for ECS Auto Scaling
# This resource allows the ECS service to scale dynamically based on usage metrics.
resource "aws_appautoscaling_target" "ecs_service" {
  max_capacity       = 10                # Maximum number of ECS tasks
  min_capacity       = 2                 # Minimum number of ECS tasks
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}" # Identifier for the ECS service
  scalable_dimension = "ecs:service:DesiredCount" # ECS scaling dimension
  service_namespace  = "ecs"             # Namespace for ECS service
}

# Scaling policy to increase ECS tasks based on CPU utilization
resource "aws_appautoscaling_policy" "scale_out" {
  name               = "ecs-scale-out"   # Name of the scaling policy
  service_namespace  = "ecs"             # Namespace for ECS service
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id # Reference the auto-scaling target
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension
  policy_type        = "TargetTrackingScaling" # Policy type for target tracking scaling
  target_tracking_scaling_policy_configuration {
    target_value       = 75.0            # CPU usage threshold
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization" # Metric to monitor
    }
    scale_in_cooldown  = 300             # Cooldown period before scaling in
    scale_out_cooldown = 300             # Cooldown period before scaling out
  }
}

# Scaling policy to decrease ECS tasks based on CPU utilization
resource "aws_appautoscaling_policy" "scale_in" {
  name               = "ecs-scale-in"    # Name of the scaling policy
  service_namespace  = "ecs"             # Namespace for ECS service
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id # Reference the auto-scaling target
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension
  policy_type        = "TargetTrackingScaling" # Policy type for target tracking scaling
  target_tracking_scaling_policy_configuration {
    target_value       = 25.0            # CPU usage threshold
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization" # Metric to monitor
    }
    scale_in_cooldown  = 300             # Cooldown period before scaling in
    scale_out_cooldown = 300             # Cooldown period before scaling out
  }
}