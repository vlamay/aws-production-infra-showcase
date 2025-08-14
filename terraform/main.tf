/**
 * Root module for the AWS Production Infra Showcase
 *
 * This file wires together the various submodules to provision
 * the entire infrastructure.  Each module encapsulates a specific
 * area of functionality such as Kubernetes, static hosting, event
 * pipelines or observability.  Variables defined in variables.tf
 * should be customised per environment.
 */

// Provision an EKS cluster using the official terraform-aws-modules/eks module
module "eks" {
  source = "./modules/eks"

  cluster_name       = var.eks_cluster_name
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  region             = var.region
}

// Install Argo CD into the EKS cluster using a Helm release.  This
// module assumes kubectl access to the cluster is configured via
// environment variables (e.g. via kubeconfig from module.eks).  You can
// customise values in modules/argocd/values.yaml.
module "argocd" {
  source = "./modules/argocd"

  cluster_name = module.eks.cluster_name
  region       = var.region
}

// Create a static website using S3 and CloudFront.  The contents of
// the docs/ folder should be synchronised to the bucket after apply.
module "static_site" {
  source       = "./modules/s3_cloudfront"
  project_name = var.project_name
  region       = var.region
}

// EventBridge rule and targets for event‑driven pipelines.  This
// module wires an EventBridge rule to a Step Functions state machine
// defined below.  Replace schedule_expression or event pattern as
// needed.
module "eventbridge" {
  source       = "./modules/eventbridge"
  project_name = var.project_name
  region       = var.region
  state_machine_arn = module.stepfunctions.state_machine_arn
}

// Define a simple Step Functions state machine.  Edit the definition
// within the module to orchestrate your own Lambda functions or
// integrations.
module "stepfunctions" {
  source       = "./modules/stepfunctions"
  project_name = var.project_name
  region       = var.region
}

// Observability: CloudWatch dashboards and SLO alarms.  Alerts can
// optionally send notifications to Slack via SNS and AWS Chatbot.
module "cloudwatch" {
  source       = "./modules/cloudwatch"
  project_name = var.project_name
  region       = var.region
  slack_workspace_id = var.slack_workspace_id
  slack_channel_id   = var.slack_channel_id
}

// IAM role for GitHub Actions OIDC integration.  This module
// configures an IAM role that can be assumed by GitHub Actions
// workflows from this repository for deploying via Terraform.  You
// must enable GitHub Actions OIDC in your AWS account.
module "iam_oidc" {
  source      = "./modules/iam_oidc"
  project     = var.project_name
  github_org  = var.github_org
  github_repo = var.github_repo
}