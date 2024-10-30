resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${random_string.suffix.result}"
  location = var.location
}

resource "azurerm_storage_account" "main" {
  name                     = "st${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "logs-${var.application_name}-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


module "diagnostic_setting" {

  source = "../../"

  resource_id        = azurerm_log_analytics_workspace.main.id
  storage_account_id = azurerm_storage_account.main.id

  prefix = var.diagnostic_prefix
  name   = var.diagnostic_name

  logs = [
    "Audit",
    "SummaryLogs"
  ]

}
