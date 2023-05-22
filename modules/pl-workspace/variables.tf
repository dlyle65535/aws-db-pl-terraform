variable "databricks_account_id" {}
variable "databricks_account_username" {}
variable "databricks_account_password" {}
variable "cross_account_arn" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "vpc_subnet_cidrs" {}
variable "security_group_id" {}
variable "root_storage_bucket" {}
variable "region" {
  default = "us-east-1"
}
variable "workspace_vpce_service" {}
variable "relay_vpce_service" {}
variable "vpce_subnet_cidr" {}
variable "private_dns_enabled" { default = true }
variable "tags" { default = {} }

locals {
  prefix = "private-link-ws"
}