/**
 * GitHub Actions OIDC IAM Role
 *
 * Defines an IAM role that can be assumed by GitHub Actions via
 * federated OIDC.  This enables secure, keyless deployment from
 * GitHub workflows without long‑lived credentials.  Adjust the
 * permissions in the deploy policy as needed.
 */

locals {
  oidc_provider_url = "token.actions.githubusercontent.com"
  subject_claim     = "repo:${var.github_org}/${var.github_repo}:*"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://${local.oidc_provider_url}"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "${local.oidc_provider_url}:sub"
      values   = [local.subject_claim]
    }
  }
}

resource "aws_iam_role" "github_deploy" {
  name               = "${var.project}-github-deploy"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "deploy" {
  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:DescribeNodegroup",
      "eks:ListClusters",
      "eks:ListNodegroups",
      "cloudformation:*",
      "s3:*",
      "cloudfront:*",
      "iam:PassRole",
      "cloudwatch:*",
      "states:*",
      "lambda:*",
      "events:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deploy" {
  name   = "${var.project}-deploy-policy"
  policy = data.aws_iam_policy_document.deploy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = aws_iam_policy.deploy.arn
}

output "role_arn" {
  description = "IAM role ARN that GitHub Actions can assume via OIDC"
  value       = aws_iam_role.github_deploy.arn
}