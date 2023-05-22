provider "aws" {
  region = var.region
}

provider "databricks" {
  host     = "https://accounts.cloud.databricks.com"
  username = var.databricks_account_username
  password = var.databricks_account_password
}

data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

data "databricks_aws_crossaccount_policy" "this" {
}

module "aws-infra" {
  source = "./modules/aws-infra"
  #todo - get this outta there
  databricks_aws_assume_role_policy  = data.databricks_aws_assume_role_policy.this.json
  databricks_aws_crossaccount_policy = data.databricks_aws_crossaccount_policy.this.json
  workspace_short_name               = var.workspace_short_name
  tags                               = var.tags
}

module "pl-workspace" {
  source                      = "./modules/pl-workspace"
  cross_account_arn           = module.aws-infra.databricks-cross-account-role-arn
  vpc_id                      = module.aws-infra.databricks-vpc-id
  databricks_account_username = var.databricks_account_username
  databricks_account_password = var.databricks_account_password
  databricks_account_id       = var.databricks_account_id
  root_storage_bucket         = aws_s3_bucket.root_storage_bucket.bucket
  vpce_subnet_cidr            = cidrsubnet("10.4.0.0/16", 3, 4)
  vpc_subnet_cidrs            = concat(module.aws-infra.databricks-private-subnet-cidr-blocks, module.aws-infra.databricks-public-subnet-cidr-blocks)
  subnet_ids                  = module.aws-infra.databricks-private-subnet-ids
  security_group_id           = module.aws-infra.databricks-vpc-sg-ids
  workspace_vpce_service      = "com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04"
  relay_vpce_service          = "com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf"
  workspace_short_name        = var.workspace_short_name
  tags                        = var.tags
  depends_on                  = [module.aws-infra]
}

module "codeartifact" {
  source               = "./modules/codeartifact"
  subnet_ids           = module.aws-infra.databricks-private-subnet-ids
  subnet_cidrs         = module.aws-infra.databricks-private-subnet-cidr-blocks
  vpc_id               = module.aws-infra.databricks-vpc-id
  workspace_short_name = var.workspace_short_name
  tags                 = var.tags
}

