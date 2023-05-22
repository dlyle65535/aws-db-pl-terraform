variable "databricks_account_username" {}
variable "databricks_account_password" {}
variable "databricks_account_id" {}
variable "workspace_vpce_service"{}
variable "relay_vpce_service" {}
variable "tags" {
  default = {}
}
variable "region" {
  default = "us-east-1"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

locals {
  prefix = "pl-workspace${random_string.naming.result}"
}
