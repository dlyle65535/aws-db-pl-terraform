variable "databricks_account_id" {
  sensitive = true
}
variable "workspace_vpce_service" {}
variable "relay_vpce_service" {}
variable "workspace_short_name" {}
variable "databricks_oauth" {
  sensitive = true
}
variable "databricks_client_id" {
  sensitive = true
}
variable "tags" {
  default = {}
}
variable "region" {
  default = "us-east-1"
}
