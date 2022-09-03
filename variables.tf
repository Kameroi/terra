variable "region" {
  description = "AWS provider region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_name" {
  description = "Name of a VPC to be created"
  type        = string
  default     = "my-vpc"
}

variable "cluster_name" {
  description = "K8S cluster name"
  type        = string
  default     = "my-cluster"
}

variable "db_name" {
  description = "Name of a DB to be created"
  type        = string
  default     = "mysqldb"
}