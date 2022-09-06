module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.22"
  cluster_endpoint_private_access = true  # allows our private endpoints to connect and join cluster
  cluster_endpoint_public_access  = true
  cluster_additional_security_group_ids = [aws_security_group.eks_security_group.id]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    instance_types         = ["t2.micro"]
    attach_cluster_primary_security_group = true
    vpc_security_group_ids = [aws_security_group.eks_security_group.id]
  }
  
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"
      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 3
      desired_size = 1

      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT

      vpc_security_group_ids = [
        aws_security_group.eks_security_group.id
      ]
    }
  }
}
