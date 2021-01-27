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

output "system_alerts_topic_arn" {
  value = aws_sns_topic.system_alerts.arn
}

module "box" {
  source = "./iam_user"

  name = "box"
  path = "/system/"
  groups = [
    aws_iam_group.system_alerts.name,
  ]
}

output "iam_user-box" {
  value = module.box
}
