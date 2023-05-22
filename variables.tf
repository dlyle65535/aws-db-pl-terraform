variable "databricks_account_username" {}
variable "databricks_account_password" {}
variable "databricks_account_id" {}
variable "workspace_vpce_service" {}
variable "relay_vpce_service" {}
variable "workspace_short_name" {}
variable "tags" {
  default = {}
}
variable "region" {
  default = "us-east-1"
}
