variable "project_name" {
  description = "Project prefix for resource names"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "slack_workspace_id" {
  description = "Slack workspace ID for AWS Chatbot notifications"
  type        = string
  default     = ""
}

variable "slack_channel_id" {
  description = "Slack channel ID for AWS Chatbot notifications"
  type        = string
  default     = ""
}