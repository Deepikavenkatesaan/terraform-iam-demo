locals {
  allowed_cb_auth_groups = toset([
    "cb-auth-development",
    "cb-auth-sandbox",
    "cb-auth-production"
  ])
}

resource "aws_iam_group" "cb_auth" {
  for_each = local.allowed_cb_auth_groups

  name = each.value
}

resource "aws_iam_user" "users" {
  for_each = var.iam_users

  name = each.key

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "IAM onboarding demo"
  }
}

resource "aws_iam_user_group_membership" "memberships" {
  for_each = var.iam_users

  user   = aws_iam_user.users[each.key].name
  groups = each.value

  depends_on = [
    aws_iam_group.cb_auth
  ]
}
