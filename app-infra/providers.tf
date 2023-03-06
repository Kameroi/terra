provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

# Authenticating
# The exec argument gets a short-lived token to authenticate to your EKS cluster.
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}