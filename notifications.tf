resource "aws_sns_topic" "system_alerts" {
  name_prefix  = "system-alerts"
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
