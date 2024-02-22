data "aws_availability_zones" "available" {}

locals {
  name    = "demo-sql-server"
  region  = "ap-south-1"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-rds"
  }
}

################################################################################
# RDS Module
################################################################################

module "rds" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "6.4.0"
  identifier = local.name


  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family # DB parameter group
  major_engine_version = var.major_engine_version             # DB option group
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  # Encryption at rest is not available for DB instances running SQL Server Express Edition
  storage_encrypted = var.storage_encrypted

  username = var.username
  port     = var.port

  multi_az               = var.multi_az
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group     = var.create_cloudwatch_log_group

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval

  options                   = []
  create_db_parameter_group = var.create_db_parameter_group
  license_model             = "license-included"
  timezone                  = "GMT Standard Time"
  character_set_name        = "Latin1_General_CI_AS"

  tags = local.tags
}
