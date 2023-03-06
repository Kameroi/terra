module "efs" {
  source  = "cloudposse/efs/aws"
  version = "0.31.0"

  namespace = "kube-wp"
  name      = "wp-content"
  region    = "eu-central-1"
  vpc_id    = module.vpc.vpc_id
  subnets   = module.vpc.private_subnets
  security_group_rules = [
    {
      "cidr_blocks" : ["0.0.0.0/0"],
      "description" : "Allow all outbound traffic",
      "from_port" : 0,
      "protocol" : "-1",
      "to_port" : 65535,
      "type" : "egress"
    },
    {
      "cidr_blocks" : ["10.0.0.0/16"],
      "description" : "Allow all traffic from within the VPC",
      "from_port" : 0,
      "protocol" : "-1",
      "to_port" : 65535,
      "type" : "ingress"
    },
  ]
}

/*
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

//data "aws_caller_identity" "current" {}

module "efs" {
  source = "terraform-aws-modules/efs/aws"
  name           = "my-efs"
  creation_token = "my-efs"
  encrypted      = false

  bypass_policy_lockout_safety_check = true
  attach_policy                      = true
  policy_statements = [
    {
      sid     = "Example"
      actions = ["elasticfilesystem:ClientMount"]
      principals = [
        {
          type        = "AWS"
          identifiers = [data.aws_caller_identity.current.arn]
        }
      ]
    }
  ]
  
  # Access point(s)
  access_points = {
    posix_wp = {
      name = "posix_wp"
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1002]
      }
    }

    root = {
      root_directory = {
        path = "/"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  }

  # Mount targets / security group
  mount_targets = { for k, v in toset(range(length(local.azs))) :
    element(local.azs, k) => { subnet_id = element(module.vpc.private_subnets, k) }
  }

  security_group_description = "Example EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id  
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }

  enable_backup_policy = false
}
*/
