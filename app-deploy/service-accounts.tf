#########################
# ALB
#########################
module "aws_load_balancer_controller_irsa_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name   = "aws-load-balancer-controller"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.state.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
      # Remember the namespace_service_accounts line, it is assuming you are 
      # going to create a service account in the kube-system namespace called 
      # aws-load-balancer-controller. 
      # Thats the default location that is used in the documentation. 
      # If you need to use a different namespace or service account name then 
      # thats fine but remember to update this module.
    }
  }
}

# kubernetes_service_account
# A service account provides an identity for processes that run in a Pod. 
# This data source reads the service account and makes specific attributes available to Terraform.
resource "kubernetes_service_account" "service-account-alb" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.aws_load_balancer_controller_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}
#########################
# EFS
#########################
module "efs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "efs-csi-controller-sa"
  attach_efs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.state.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
}

resource "kubernetes_service_account" "service-account-efs" {
  metadata {
    name = "efs-csi-controller-sa"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "efs-csi-controller-sa"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.efs_csi_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}
#########################
# Karpenter
#########################


/*
module "karpenter_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                          = "karpenter-controller"
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id         = data.terraform_remote_state.state.outputs.cluster_id
  karpenter_controller_node_iam_role_arns = [module.eks.eks_managed_node_groups["default"].iam_role_arn] ###########

  oidc_providers = {
    ex = {
      provider_arn               = data.terraform_remote_state.state.outputs.oidc_provider_arn
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }

  tags = local.tags
}

resource "kubernetes_service_account" "service-account-karpenter" {
  metadata {
    name = "karpenter-sa"
    #namespace = "kube-system"
    namespace = "karpenter"
    labels = {
        "app.kubernetes.io/name"= "karpenter-sa"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.karpenter_controller_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}*/