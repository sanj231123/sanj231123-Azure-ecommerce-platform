resource "azurerm_monitor_diagnostic_setting" "aks" {

  name = "aks-diagnostics"

  target_resource_id = var.aks_id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "acr" {

  name = "acr-diagnostics"

  target_resource_id = var.acr_id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage" {

  name = "storage-diagnostics"

  target_resource_id = var.storage_account_id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_metric {
    category = "Transaction"
  }
}

resource "azurerm_monitor_diagnostic_setting" "keyvault" {

  name = "keyvault-diagnostics"

  target_resource_id = var.key_vault_id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}
