resource "aws_sns_topic" "system_alerts" {
  name         = "system-alerts"
  display_name = "sysalert"
}

resource "aws_sns_sms_preferences" "sms_prefs" {
  monthly_spend_limit = 1
  default_sender_id   = "jaanxyz"
}

resource "aws_sns_topic_subscription" "system_alerts-sms" {
  topic_arn = aws_sns_topic.system_alerts.arn
  protocol  = "sms"
  endpoint  = var.alerts_sms_number
}

resource "aws_iam_group" "system_alerts" {
  name = "system-alerts"
}

resource "aws_iam_group_policy" "allow_system_alerts_publish" {
  name   = "system-alerts-publish"
  group  = aws_iam_group.system_alerts.name
  policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": {
          "Effect": "Allow",
          "Action": "sns:Publish",
          "Resource": "${aws_sns_topic.system_alerts.arn}"
      }
  }
  EOF
}

resource "aws_iam_user" "box" {
  name = "box"
  path = "/system/"
}

resource "aws_iam_user_group_membership" "box" {
  user = aws_iam_user.box.name
  groups = [
    aws_iam_group.system_alerts.name,
  ]
}

resource "aws_iam_access_key" "box" {
  user = aws_iam_user.box.name
}

output "system_alerts_topic_arn" {
  value = aws_sns_topic.system_alerts.arn
}

output "box-aws_access_key_id" {
  value = aws_iam_access_key.box.id
}

output "box-aws_secret_access_key" {
  value     = aws_iam_access_key.box.secret
  sensitive = true
}
