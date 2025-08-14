/**
 * Observability Module
 *
 * Creates a simple CloudWatch dashboard and SLO alarms.  Optionally
 * configures an SNS topic and AWS Chatbot integration for Slack.
 */

locals {
  dashboard_name = "${var.project_name}-dashboard"
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = local.dashboard_name
  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 0,
        "y" : 0,
        "width" : 24,
        "height" : 6,
        "properties" : {
          "metrics" : [
            ["AWS/CloudFront", "Requests", "DistributionId", "${var.project_name}-static-site", { "stat" : "Sum" }],
            [".", "4xxErrorRate", "DistributionId", "${var.project_name}-static-site", { "stat" : "Average" }],
            [".", "5xxErrorRate", "DistributionId", "${var.project_name}-static-site", { "stat" : "Average" }]
          ],
          "title" : "Static Site Requests & Errors",
          "region" : var.region
        }
      }
    ]
  })
}

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

resource "aws_cloudwatch_metric_alarm" "availability_slo" {
  alarm_name          = "${var.project_name}-availability-slo"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold           = 99.9
  metric_name         = "Availability"
  namespace           = "Custom/SLO"
  statistic           = "Average"
  period              = 300
  alarm_description   = "Static site availability below 99.9%"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "latency_slo" {
  alarm_name          = "${var.project_name}-latency-slo"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0.2
  metric_name         = "LatencyP90"
  namespace           = "Custom/SLO"
  statistic           = "Average"
  period              = 300
  alarm_description   = "Static site latency (p90) exceeds 200ms"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alerts.arn]
}

# Optionally configure AWS Chatbot for Slack notifications.  Both
# workspace and channel IDs must be provided for this resource to be
# created.  The service will subscribe the SNS topic to the Slack
# channel.
resource "aws_chatbot_slack_channel_configuration" "slack" {
  count              = var.slack_workspace_id != "" && var.slack_channel_id != "" ? 1 : 0
  name               = "${var.project_name}-slack-chatbot"
  slack_channel_id   = var.slack_channel_id
  slack_workspace_id = var.slack_workspace_id
  sns_topic_arns     = [aws_sns_topic.alerts.arn]
  logging_level      = "ERROR"
}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = local.dashboard_name
}