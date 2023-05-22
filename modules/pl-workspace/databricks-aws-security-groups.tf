resource "aws_security_group" "dataplane_vpce" {
  name        = "Data Plane VPC endpoint security group"
  description = "Security group shared with relay and workspace endpoints"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset([
      443,
      2443, # FIPS port for CSP
      6666,
    ])

    content {
      description = "Inbound rules"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.vpc_subnet_cidrs
    }
  }

  dynamic "egress" {
    for_each = toset([
      443,
      2443, # FIPS port for CSP
      6666,
    ])

    content {
      description = "Outbound rules"
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = var.vpc_subnet_cidrs
    }
  }
  tags = merge(var.tags, { Name = "${var.workspace_short_name}-dp-vpce-sg-rules" })
}
