# AWS Production Infra Showcase

This repository demonstrates a **production‑grade AWS infrastructure** using a variety of AWS services, Infrastructure‑as‑Code tools and CI/CD practices.  It is designed as a template to showcase how to combine managed Kubernetes, serverless applications, static content hosting, event‑driven pipelines and observability into one cohesive project.  You can use it as a starting point for your own projects or as a portfolio piece to demonstrate your DevOps skills.

## Features

* **Amazon EKS** – A managed Kubernetes cluster to run containerised workloads.  The configuration uses the well‑maintained `terraform-aws-modules/eks/aws` module to create a cluster and node groups.  Kubernetes manifests live under the `k8s/` directory.
* **Argo CD** – A GitOps controller installed into the EKS cluster via Helm.  This repository contains a placeholder manifest for Argo CD; you can replace it with the official install manifest.  Argo CD will watch the repository and synchronise Kubernetes manifests automatically.
* **S3 + CloudFront** – A static website is hosted in an S3 bucket and served globally via a CloudFront distribution.  This powers the GitHub Pages–style demo contained in the `docs/` folder.
* **EventBridge and Step Functions** – An EventBridge rule triggers a Step Functions state machine on a schedule (or based on events).  The sample state machine demonstrates orchestrating two Lambda tasks.  Edit the state machine definition to suit your workflows.
* **SAM and CDK examples** – Under `sam/` and `cdk/` are minimal examples of AWS SAM and AWS CDK applications.  These serve as starting points for building additional services using your preferred IaC framework.
* **CloudWatch Dashboards & SLO Alerts** – A basic dashboard illustrates how to visualise metrics.  You can expand this file to include application latency, error rates and any other KPIs.  Alarms and notifications to Slack (via SNS and Chatbot) are hinted at in the code.
* **Terraform Backend** – The Terraform state is stored remotely in an S3 bucket with a DynamoDB table providing a distributed lock.  Adjust the bucket names before running `terraform init`.
* **CI/CD via GitHub Actions** – Workflows defined in `.github/workflows/` run Terraform to provision infrastructure and validate configuration on pull requests.  You can extend these workflows to build container images, push to ECR and deploy via Argo CD.

## Repository Layout

```
aws-production-infra-showcase/
├── docs/                  # Static site (dark and light themes) for GitHub Pages and CloudFront
├── terraform/             # Terraform configuration for all AWS resources
├── k8s/                   # Kubernetes manifests (Argo CD install and sample apps)
├── sam/                   # AWS SAM example
├── cdk/                   # AWS CDK example
├── .github/workflows/     # GitHub Actions pipelines
└── README.md              # Project overview and usage
```

## Getting Started

### Prerequisites

* [Terraform](https://developer.hashicorp.com/terraform/downloads) ≥ 1.5
* [kubectl](https://kubernetes.io/docs/tasks/tools/) and [helm](https://helm.sh/docs/intro/install/)
* AWS CLI configured with sufficient privileges to create EKS clusters, IAM roles, S3 buckets, CloudFront distributions, Step Functions, etc.
* SSH access to your GitHub account configured if you plan to deploy via GitHub Actions and Argo CD.

### Provision the Infrastructure

1. Edit `terraform/backend.tf` and adjust the `bucket` and `dynamodb_table` names to unique values for your account.
2. Run `terraform init` from the `terraform` directory to initialise the backend.
3. Run `terraform plan` to review the changes.
4. Run `terraform apply` to create the infrastructure.  Terraform will output the CloudFront domain name for the static site.

The Terraform configuration intentionally leaves some values blank (such as VPC ID and subnet IDs).  Replace these with values from your environment.

### Deploy Argo CD

The `k8s/argocd-install.yaml` file contains a placeholder manifest.  Replace its contents with the official Argo CD install manifest from the [Argo CD releases page](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd).

Apply the manifest and wait for the pods to become ready:

```bash
kubectl apply -f k8s/argocd-install.yaml
kubectl get pods -n argocd
```

To expose the Argo CD UI, port‑forward or use the LoadBalancer service created by the Helm release defined in Terraform.

### Static Site

The static site is located in the `docs/` folder.  It contains dark and light themes and a call‑to‑action button linking back to your GitHub repository.  You can extend this site to document your infrastructure or host a personal portfolio.  After provisioning, synchronise the contents of `docs/` to the S3 bucket:

```bash
aws s3 sync docs/ s3://$(terraform -chdir=terraform output -raw static_site_bucket)
```

### EventBridge and Step Functions

The sample EventBridge rule triggers a scheduled pipeline every 5 minutes.  The state machine definition shows how to orchestrate two Lambda functions.  Replace the ARN placeholders with the ARNs of your own functions or other integrated services.

### Observability and Alerts

CloudWatch dashboards and alarms are defined in the Terraform configuration.  Extend the `dashboard_body` JSON to plot relevant metrics such as API latency, error rates and invocation counts.  Slack notifications can be configured by integrating an SNS topic with AWS Chatbot and providing a webhook URL via the `slack_webhook_url` variable.

### Contributing

This project is intended as a starting point.  Feel free to contribute additional modules, improve the workflows, or adapt it for your own needs.