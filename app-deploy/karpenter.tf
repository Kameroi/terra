module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 19.0"

  cluster_name = var.cluster_name

  irsa_oidc_provider_arn          = data.terraform_remote_state.state.outputs.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  # Since Karpenter is running on an EKS Managed Node group,
  # we can re-use the role that was created for the node group
  create_iam_role = false
  #iam_role_arn = module.eks.eks_managed_node_groups["initial"].iam_role_arn
  iam_role_arn = data.terraform_remote_state.state.outputs.eks_managed_node_groups_iam_role_arn
}

# https://github.com/hashicorp/terraform-provider-aws/issues/28281
# Workaround needed for helm before v2.8.0
provider "aws" {
  region = "us-east-1"
  alias = "virginia"
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

resource "helm_release" "karpenter" {
  timeout = 180
  namespace        = "karpenter"
  create_namespace = true

  name             = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart            = "karpenter"
  version          = "v0.22.1"

  set {
    name  = "settings.aws.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = data.terraform_remote_state.state.outputs.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.irsa_arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = module.karpenter.queue_name
  }
}