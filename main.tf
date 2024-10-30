resource "random_uuid" "suffix" {

  count = var.randomize ? 1 : 0

}

locals {
  user_specified_name_segment = var.name == "" ? "" : "-${var.name}"
  generated_name              = var.randomize ? "${var.prefix}${local.user_specified_name_segment}-${random_uuid.suffix[0].result}" : "${var.prefix}${local.user_specified_name_segment}"
}

resource "azurerm_monitor_diagnostic_setting" "main" {

  name                           = local.generated_name
  target_resource_id             = var.resource_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  storage_account_id             = var.storage_account_id
  eventhub_name                  = var.eventhub_name
  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "enabled_log" {
    for_each = var.logs
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.metrics
    content {
      category = metric.value
      enabled  = true
    }
  }
}
