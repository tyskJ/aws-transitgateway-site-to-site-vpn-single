/************************************************************
CloudWatch Logs
************************************************************/
resource "aws_cloudwatch_log_group" "this" {
  for_each = local.logs

  name                        = each.value.name
  retention_in_days           = each.value.retention_day
  deletion_protection_enabled = false
  log_group_class             = "STANDARD"
  tags = {
    Name = each.value.name
  }
}