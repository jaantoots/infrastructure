output "name" {
  value = aws_iam_user.this.name
}

output "aws_access_key_id" {
  value = aws_iam_access_key.this.id
}

output "aws_secret_access_key" {
  value = aws_iam_access_key.this.secret
}
