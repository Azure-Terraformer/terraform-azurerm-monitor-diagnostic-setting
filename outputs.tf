output "id" {
  value       = azurerm_monitor_diagnostic_setting.main.id
  description = "Diagnosting Setting ID"
}
output "name" {
  value = azurerm_monitor_diagnostic_setting.main.name
}
