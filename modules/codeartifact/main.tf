resource "aws_kms_key" "lyleco" {
  description = "domain key"
}

resource "aws_codeartifact_domain" "lyleco" {
  domain         = "lyleco"
  encryption_key = aws_kms_key.lyleco.arn
}

resource "aws_codeartifact_repository" "maven" {
  repository = "maven"
  domain     = aws_codeartifact_domain.lyleco.domain
  upstream {
    repository_name = aws_codeartifact_repository.maven_central.repository
  }
}

resource "aws_codeartifact_repository" "maven_central" {
  repository = "maven-central-store"
  domain     = aws_codeartifact_domain.lyleco.domain
  external_connections {
    external_connection_name = "public:maven-central"
  }
}

resource "aws_vpc_endpoint" "codeartifact-api" {
  for_each = toset([
    "com.amazonaws.us-east-1.codeartifact.api",
    "com.amazonaws.us-east-1.codeartifact.repositories",
  ])

  service_name        = each.value
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.codeartifact.id]
  subnet_ids          = var.subnet_ids
  private_dns_enabled = true
}

