/**
 * Outputs from the top‑level module.  These values provide URLs
 * and identifiers useful for interacting with the deployed
 * infrastructure.
 */

output "static_site_bucket" {
  description = "Name of the S3 bucket hosting the static site"
  value       = module.static_site.bucket_name
}

output "static_site_domain" {
  description = "Domain name of the CloudFront distribution"
  value       = module.static_site.cloudfront_domain
}

output "eks_cluster_name" {
  description = "Name of the provisioned EKS cluster"
  value       = module.eks.cluster_name
}

output "stepfunctions_state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = module.stepfunctions.state_machine_arn
}

output "eventbridge_rule_name" {
  description = "Name of the EventBridge rule that triggers the state machine"
  value       = module.eventbridge.rule_name
}

output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = module.cloudwatch.dashboard_name
}

output "iam_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions via OIDC"
  value       = module.iam_oidc.role_arn
}