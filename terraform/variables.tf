/**
 * Global variables for the AWS Production Infra Showcase.
 *
 * These variables allow customisation of the project name, AWS region
 * and other parameters used throughout the Terraform configuration.
 */

variable "project_name" {
  description = "Prefix used to name resources (e.g. s3 buckets, state machine)"
  type        = string
}

variable "region" {
  description = "AWS region where all resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "backend_bucket" {
  description = "Name of the S3 bucket used for the Terraform backend"
  type        = string
}

variable "backend_dynamodb_table" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC into which the EKS cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS worker nodes"
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
  default     = "prod-eks-cluster"
}

variable "github_org" {
  description = "GitHub organisation or user name used for OIDC trust"
  type        = string
}

variable "github_repo" {
  description = "Repository name used for OIDC trust (without org)"
  type        = string
}

variable "slack_workspace_id" {
  description = "ID of the Slack workspace used for AWS Chatbot integration"
  type        = string
  default     = ""
}

variable "slack_channel_id" {
  description = "ID of the Slack channel that will receive alerts"
  type        = string
  default     = ""
}