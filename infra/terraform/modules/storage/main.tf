resource "azurerm_storage_account" "this" {

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  min_tls_version = "TLS1_2"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_container" "this" {

  name = var.container_name

  storage_account_id = azurerm_storage_account.this.id

  container_access_type = "private"
}
