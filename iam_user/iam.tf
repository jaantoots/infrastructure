resource "aws_iam_user" "this" {
  name = var.name
  path = var.path
}

resource "aws_iam_user_group_membership" "this" {
  user   = aws_iam_user.this.name
  groups = var.groups
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}
