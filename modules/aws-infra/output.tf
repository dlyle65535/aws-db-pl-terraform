output "databricks-vpc-id" {
  value = module.vpc.vpc_id
}

output "databricks-cross-account-role-arn" {
  value = aws_iam_role.cross_account_role.arn
}

output "databricks-private-subnet-cidr-blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "databricks-public-subnet-cidr-blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "databricks-public-subnet-ids" {
  value = module.vpc.public_subnets
}

output "databricks-private-subnet-ids" {
  value = module.vpc.private_subnets
}

output "databricks-vpc-sg-ids" {
  value = module.vpc.default_security_group_id
}
