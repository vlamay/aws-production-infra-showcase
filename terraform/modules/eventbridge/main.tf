/**
 * EventBridge Scheduler Module
 *
 * Creates an EventBridge rule that triggers the provided Step Functions
 * state machine on a schedule.  You can replace the schedule or
 * configure a custom event pattern as needed.
 */

locals {
  rule_name = "${var.project_name}-scheduler"
}

resource "aws_cloudwatch_event_rule" "scheduler" {
  name                = local.rule_name
  description         = "Run state machine on a fixed schedule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "sfn" {
  rule      = aws_cloudwatch_event_rule.scheduler.name
  target_id = "StepFunctionTarget"
  arn       = var.state_machine_arn
}


output "rule_name" {
  description = "Name of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.scheduler.name
}