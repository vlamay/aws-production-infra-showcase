variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to deploy the EKS cluster into"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnets for the EKS worker nodes"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}