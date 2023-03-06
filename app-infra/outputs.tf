################################################################################
# VPC
################################################################################

output "region" {
  description = "AWS region"
  value       = var.region
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = var.vpc_name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

################################################################################
# EKS
################################################################################

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.cluster_name
}

output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "oidc_provider_arn" {
  description = "oidc_provider_arn"
  value       = module.eks.oidc_provider_arn
}

output "eks_managed_node_groups_iam_role_arn" {
  description = "oidc_provider_arn"
  value       = module.eks.eks_managed_node_groups["initial"].iam_role_arn
}
################################################################################
# RDS Aurora
################################################################################

output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = module.aurora.cluster_endpoint
}

################################################################################
# EFS
################################################################################

output "efs_file_system_id" {
  description = "The ID that identifies the file system (e.g., `fs-ccfc0d65`)"
  value       = module.efs.id
}

################################################################################
# RDS OLD
################################################################################
/*
output "db_instance_port" {
  description = "The database port"
  value       = module.db.db_instance_port
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.db.db_instance_username
  sensitive   = true
}

output "db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.db.db_instance_password
  sensitive   = true
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.db_instance_address
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.db_instance_id
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.db_instance_endpoint
}*/