module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Demo SQL server security group "
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      description = "SqlServer access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
  # egress
  egress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      description              = "Allow outbound communication to Directory Services security group"
      source_security_group_id = module.security_group.security_group_id
    },
  ]

  tags = local.tags
}