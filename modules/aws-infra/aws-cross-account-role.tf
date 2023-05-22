resource "aws_iam_role" "cross_account_role" {
  name               = "${var.workspace_short_name}-crossaccount"
  assume_role_policy = var.databricks_aws_assume_role_policy
  tags               = merge(var.tags, { Name = "${var.workspace_short_name}-crossaccount" })
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.workspace_short_name}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = var.databricks_aws_crossaccount_policy
}

