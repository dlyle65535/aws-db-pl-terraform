variable "databricks_aws_assume_role_policy" {}
variable "databricks_aws_crossaccount_policy" {}
variable "tags" {
  default = {}
}

variable "cidr_block" {
  default = "10.4.0.0/16"
}

variable "region" {
  default = "us-east-1"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

variable "private_dns_enabled" { default = true }

locals {
  prefix = "pl-workspace${random_string.naming.result}"
}
