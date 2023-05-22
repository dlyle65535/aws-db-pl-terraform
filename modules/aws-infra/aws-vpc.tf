data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = var.workspace_short_name
  cidr = var.cidr_block
  azs  = data.aws_availability_zones.available.names
  tags = merge(var.tags, { Name = "${var.workspace_short_name}-crossaccount" })

  enable_dns_hostnames = true
  enable_nat_gateway   = false
  create_igw           = true

  public_subnets = [cidrsubnet(var.cidr_block, 3, 0)]
  private_subnets = [cidrsubnet(var.cidr_block, 3, 1),
  cidrsubnet(var.cidr_block, 3, 2), cidrsubnet(var.cidr_block, 3, 3)]

  manage_default_security_group = true
  default_security_group_name   = "${var.workspace_short_name}-sg"

  default_security_group_egress = [{
    cidr_blocks = "0.0.0.0/0"
  }]

  default_security_group_ingress = [{
    description = "Allow all internal TCP and UDP"
    self        = true
    },
    {
      decription  = "Allow SSH"
      cidr_blocks = "0.0.0.0/0"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    }
  ]
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.2.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc.default_security_group_id]

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
      route_table_ids = flatten([
        module.vpc.private_route_table_ids,
      module.vpc.public_route_table_ids])
      tags = merge(var.tags, { Name = "${var.workspace_short_name}-s3-vpc-endpoint" })
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = merge(var.tags, { Name = "${var.workspace_short_name}-sts-vpc-endpoint" })
    }
  }

  tags = merge(var.tags, { Name = "${var.workspace_short_name}" })
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [module.vpc]
  tags       = merge(var.tags, { Name = "${var.workspace_short_name}-nat-eip" })
}

resource "aws_nat_gateway" "hive_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = module.vpc.public_subnets[0]
  tags          = merge(var.tags, { Name = "${var.workspace_short_name}-nat-gateway" })
}

resource "aws_route_table" "hive_metastore" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "54.167.172.164/32"
    nat_gateway_id = aws_nat_gateway.hive_nat.id
  }
  tags = merge(var.tags, { Name = "${var.workspace_short_name}-nat-routes" })
}

resource "aws_route" "private_to_nat" {
  for_each               = { for i, v in flatten(module.vpc.private_route_table_ids) : i => v }
  route_table_id         = each.value
  destination_cidr_block = "54.167.172.164/32"
  nat_gateway_id         = aws_nat_gateway.hive_nat.id
  depends_on             = [module.vpc]
}
