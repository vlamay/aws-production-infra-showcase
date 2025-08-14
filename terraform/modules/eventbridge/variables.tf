variable "project_name" {
  description = "Prefix for naming resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "state_machine_arn" {
  description = "ARN of the Step Functions state machine to trigger"
  type        = string
}