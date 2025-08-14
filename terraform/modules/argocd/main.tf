/**
 * Argo CD Installation Module
 *
 * This module deploys Argo CD into the EKS cluster using the
 * official Helm chart.  It assumes that a Kubernetes provider
 * configuration is available in the root module or via the
 * environment (e.g. by exporting KUBECONFIG).  If you wish to
 * configure the provider explicitly from Terraform, you can pass
 * `kubeconfig` as a variable and configure the helm provider here.
 */

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.0"
  namespace        = "argocd"
  create_namespace = true

  # Optionally include values to override defaults.  You can
  # customise these by editing the values.yaml file in this module.
  values = [file("${path.module}/values.yaml")]
}

output "argocd_release" {
  value = helm_release.argocd.name
}