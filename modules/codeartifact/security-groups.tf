data "aws_security_groups" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "codeartifact" {
  name        = "Code Artifact Endpoint Security Group"
  description = "Allows 443 for Codeartifact"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = data.aws_security_groups.selected.ids
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = merge(var.tags, { Name = "${var.workspace_short_name}-codeartifact-vpc-sg" })
}

