resource "aws_vpc_endpoint" "backend_rest" {
  vpc_id              = var.vpc_id
  service_name        = var.workspace_vpce_service
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.dataplane_vpce.id]
  subnet_ids          = [aws_subnet.dataplane_vpce.id]
  private_dns_enabled = var.private_dns_enabled
  depends_on          = [aws_subnet.dataplane_vpce]
}

resource "aws_vpc_endpoint" "relay" {
  vpc_id              = var.vpc_id
  service_name        = var.relay_vpce_service
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.dataplane_vpce.id]
  subnet_ids          = [aws_subnet.dataplane_vpce.id]
  private_dns_enabled = var.private_dns_enabled
  depends_on          = [aws_subnet.dataplane_vpce]
}

resource "databricks_mws_vpc_endpoint" "backend_rest_vpce" {
  provider            = databricks
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.backend_rest.id
  vpc_endpoint_name   = "${var.workspace_short_name}-vpc-backend-${var.vpc_id}"
  region              = var.region
  depends_on          = [aws_vpc_endpoint.backend_rest]
}

resource "databricks_mws_vpc_endpoint" "relay" {
  provider            = databricks
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.relay.id
  vpc_endpoint_name   = "${var.workspace_short_name}-vpc-relay-${var.vpc_id}"
  region              = var.region
  depends_on          = [aws_vpc_endpoint.relay]
}

resource "databricks_mws_networks" "this" {
  provider           = databricks
  account_id         = var.databricks_account_id
  network_name       = "${var.workspace_short_name}-network"
  security_group_ids = [var.security_group_id]
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id
  vpc_endpoints {
    dataplane_relay = [databricks_mws_vpc_endpoint.relay.vpc_endpoint_id]
    rest_api        = [databricks_mws_vpc_endpoint.backend_rest_vpce.vpc_endpoint_id]
  }
}
