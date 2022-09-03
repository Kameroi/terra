# skip_final_snapshot    = true 
# True to disable taking a final backup when you destroy the database later.
module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = var.db_name # The name of the RDS instance

  engine               = "mysql"
  engine_version       = "8.0.27"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  instance_class       = "db.t3.micro"

  allocated_storage    = 20
  max_allocated_storage = 22

  db_name  = "database1"
  username = "user"
  port     = "3306"

  multi_az               = true
  # Required to create DB in specified VPC, not the default one
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  # Database Deletion Protection
  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]
}