provider "aws" {
  region = var.region
}

provider "databricks" {
  host          = "https://accounts.cloud.databricks.com"
  client_id     = var.databricks_client_id
  client_secret = var.databricks_oauth
  account_id    = var.databricks_account_id
}

data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

data "databricks_aws_crossaccount_policy" "this" {
}

data "aws_iam_policy_document" "complete" {
  source_policy_documents = [ data.databricks_aws_crossaccount_policy.this.json ]

  statement {
    sid = "InstanceProfileAssumes"
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = ["arn:aws:iam::760749160151:role/Codeartifact-Databricks", "arn:aws:iam::760749160151:role/dbx-*"]
  }
}

module "aws-infra" {
  source                             = "./modules/aws-infra"
  databricks_aws_assume_role_policy  = data.databricks_aws_assume_role_policy.this.json
  databricks_aws_crossaccount_policy = data.aws_iam_policy_document.complete.json
  workspace_short_name               = var.workspace_short_name
  tags                               = var.tags
}

module "pl-workspace" {
  source                 = "./modules/pl-workspace"
  cross_account_arn      = module.aws-infra.databricks-cross-account-role-arn
  vpc_id                 = module.aws-infra.databricks-vpc-id
  databricks_account_id  = var.databricks_account_id
  root_storage_bucket    = aws_s3_bucket.root_storage_bucket.bucket
  vpce_subnet_cidr       = cidrsubnet("10.4.0.0/16", 3, 4)
  vpc_subnet_cidrs       = concat(module.aws-infra.databricks-private-subnet-cidr-blocks, module.aws-infra.databricks-public-subnet-cidr-blocks)
  subnet_ids             = module.aws-infra.databricks-private-subnet-ids
  security_group_id      = module.aws-infra.databricks-vpc-sg-ids
  workspace_vpce_service = "com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04"
  relay_vpce_service     = "com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf"
  workspace_short_name   = var.workspace_short_name
  tags                   = var.tags
  depends_on             = [module.aws-infra]
}

module "codeartifact" {
  source               = "./modules/codeartifact"
  subnet_ids           = module.aws-infra.databricks-private-subnet-ids
  subnet_cidrs         = module.aws-infra.databricks-private-subnet-cidr-blocks
  vpc_id               = module.aws-infra.databricks-vpc-id
  workspace_short_name = var.workspace_short_name
  tags                 = var.tags
}

