variable "databricks_account_id" {}
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
variable "workspace_short_name" {}
variable "relay_vpce_service" {}
variable "vpce_subnet_cidr" {}
variable "private_dns_enabled" { default = true }
variable "tags" { default = {} }
