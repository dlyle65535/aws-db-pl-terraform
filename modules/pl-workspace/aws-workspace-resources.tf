resource "databricks_mws_credentials" "this" {
  provider         = databricks
  account_id       = var.databricks_account_id
  role_arn         = var.cross_account_arn
  credentials_name = "${var.workspace_short_name}-credentials"
}
