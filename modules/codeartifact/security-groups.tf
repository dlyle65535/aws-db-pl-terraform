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
  tags = merge(var.tags, { Name = "${var.workspace_short_name}-codeartifact-vpc-sg" })
}

