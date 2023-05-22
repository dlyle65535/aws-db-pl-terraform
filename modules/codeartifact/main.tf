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

