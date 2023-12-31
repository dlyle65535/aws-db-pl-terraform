resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks
  account_id                 = var.databricks_account_id
  bucket_name                = var.root_storage_bucket
  storage_configuration_name = "${var.workspace_short_name}-storage"
}

resource "databricks_mws_private_access_settings" "pas" {
  provider                     = databricks
  account_id                   = var.databricks_account_id
  private_access_settings_name = "Private Access Settings for ${var.workspace_short_name}"
  region                       = var.region
  public_access_enabled        = true
}

resource "databricks_mws_workspaces" "this" {
  provider                   = databricks
  account_id                 = var.databricks_account_id
  aws_region                 = var.region
  workspace_name             = var.workspace_short_name
  credentials_id             = databricks_mws_credentials.this.credentials_id
  storage_configuration_id   = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id                 = databricks_mws_networks.this.network_id
  private_access_settings_id = databricks_mws_private_access_settings.pas.private_access_settings_id
  pricing_tier               = "ENTERPRISE"
  depends_on                 = [databricks_mws_networks.this]
}
