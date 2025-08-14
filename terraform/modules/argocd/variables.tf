variable "cluster_name" {
  description = "Name of the EKS cluster where Argo CD will be installed"
  type        = string
}

variable "region" {
  description = "AWS region for provider configuration"
  type        = string
}