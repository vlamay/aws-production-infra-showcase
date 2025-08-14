variable "project" {
  description = "Project prefix used in naming IAM role"
  type        = string
}

variable "github_org" {
  description = "GitHub organisation or user"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (without org)"
  type        = string
}