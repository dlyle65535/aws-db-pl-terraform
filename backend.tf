terraform {
  backend "s3" {
    bucket         = "dlyle-databricks-terraform-state"
    key            = "pl-workspace/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}
