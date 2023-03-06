module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.24"
  cluster_endpoint_private_access = true  # allows our private endpoints to connect and join cluster
  cluster_endpoint_public_access  = true
  cluster_additional_security_group_ids = [aws_security_group.eks-security-group.id]
  # without ^ everything works fine, however wp pods are restarting
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  enable_irsa = true

  node_security_group_tags = { "karpenter.sh/discovery" = var.cluster_name }

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.medium"]
      #capacity_type = "SPOT"
      create_security_group = false

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }
}