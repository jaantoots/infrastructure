resource "aws_iam_account_password_policy" "main" {
  minimum_password_length        = 16
  allow_users_to_change_password = true
}

resource "aws_key_pair" "cloud" {
  key_name   = "cloud"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBX3YVqV+WaNW1EbD6qTdEROpMcfLEOXWTFLMwaU5kZecGu6qKdMNJTroBxrS4IqaKqCCgZiUwJQQ+UOC1j9RwCRnHbeWnT5iJxSqvsPFN/qtSHJaua6PptRuAQ7ar+/rd/jpKTp1VUMonJ7urHoi7FbgoFdsq6mtKNzdEuMtNmNNB5ajVIasoIbJBhc3BQ4DYRCIAtkpUmpoH2fwXIgo1mBtvB8hz/sFlWladCB3hqwzkpgZt1dfB7qRHV7TZapmQGygThjIFZPVufO+CZ2jmrQUWmom1XgFP9TyuwMbgGO7QoRFPMV6ikrVioJImuNdYCo/pDO+/zuKdS3ErJFxo8S2c8zsIJhqh4sO193V3taYLm4GbsAofOU4WuIahPmNNn8Qi+U71oK0/6BI3CfMNPHnqW+p3NC4zHZef40os68V8YiwYB/pboRFOC6WuYHXAIpnaUrQm+WoEn49m4r52ym5UbxWlZTr7vv/WjwmJe0W2jewWA0VvQmAF2I/1kvE= jaan-cloud"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "trail" {
  bucket = "jaan-aws2020-log"
}

resource "aws_cloudtrail" "management_trail" {
  name                          = "management-trail"
  s3_bucket_name                = aws_s3_bucket.trail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

resource "aws_s3_bucket_public_access_block" "trail" {
  bucket                  = aws_s3_bucket.trail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "trail" {
  bucket = aws_s3_bucket.trail.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.trail.id}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.trail.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "deny_trail" {
  name        = "S3CloudTrailDeny"
  description = "Deny access to CloudTrail logs saved to S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.trail.id}",
                "arn:aws:s3:::${aws_s3_bucket.trail.id}/*"
            ]
        }
    ]
}
EOF
}
