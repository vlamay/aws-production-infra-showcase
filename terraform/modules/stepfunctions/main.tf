/**
 * Step Functions Module
 *
 * Defines a minimal AWS Step Functions state machine.  The default
 * definition simply passes through two states.  Replace the
 * definition JSON with your own to orchestrate Lambda functions or
 * integrate with other AWS services.  The IAM role attached to the
 * state machine grants minimal permissions; extend it as required.
 */

resource "aws_iam_role" "sfn_role" {
  name = "${var.project_name}-sfn-role"
  assume_role_policy = data.aws_iam_policy_document.sfn_assume.json
}

data "aws_iam_policy_document" "sfn_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.${var.region}.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "sfn_policy" {
  name   = "${var.project_name}-sfn-policy"
  policy = data.aws_iam_policy_document.sfn_permissions.json
}

data "aws_iam_policy_document" "sfn_permissions" {
  # Minimal permissions: adjust to allow state machine tasks to call
  # Lambda functions or other services.
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = aws_iam_policy.sfn_policy.arn
}

resource "aws_sfn_state_machine" "this" {
  name     = "${var.project_name}-state-machine"
  role_arn = aws_iam_role.sfn_role.arn
  definition = <<EOF
{
  "Comment": "Sample state machine for the AWS Production Infra Showcase",
  "StartAt": "Task1",
  "States": {
    "Task1": {
      "Type": "Pass",
      "Result": "Hello",
      "Next": "Task2"
    },
    "Task2": {
      "Type": "Pass",
      "Result": "World",
      "End": true
    }
  }
}
EOF
}

output "state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = aws_sfn_state_machine.this.arn
}