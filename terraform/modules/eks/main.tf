/**
 * EKS Cluster Module
 *
 * This module provisions an Amazon EKS cluster using the
 * terraform‑aws‑modules/eks/aws module.  It creates a control plane,
 * managed node group and configures the Kubernetes API server to
 * automatically discover the worker node IAM role via the AWS IAM
 * authenticator.  You can customise the node group configuration by
 * editing the node_groups map below.
 */

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

  # Manage the aws-auth ConfigMap automatically
  manage_aws_auth_configmap = true

  # Example managed node group.  Adjust instance type and scaling
  # values to meet your requirements.
  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.large"]
    }
  }
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}