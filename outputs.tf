output "databricks_workspace_url" {
  value = module.pl-workspace.workspace_url
}

output "databricks_cross_account_arn" {
  value = module.aws-infra.databricks-cross-account-role-arn
}

output "databricks_vpc_id" {
  value = module.aws-infra.databricks-vpc-id
}

output "databricks_root_storage_bucket" {
  value = aws_s3_bucket.root_storage_bucket.bucket
}

