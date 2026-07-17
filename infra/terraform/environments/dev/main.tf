module "resource_group" {
  source = "../../modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
  project_name        = var.project_name
}

module "acr" {

  source = "../../modules/acr"

  resource_group_name = module.resource_group.resource_group_name

  location = var.location

  environment = var.environment

  project_name = var.project_name

  acr_name = var.acr_name
}

module "log_analytics" {

  source = "../../modules/log-analytics"

  resource_group_name = module.resource_group.resource_group_name

  location = var.location

  project_name = var.project_name

  environment = var.environment

  workspace_name = var.workspace_name

  sku = var.workspace_sku

  retention_in_days = var.retention_in_days
}

module "aks" {

  source = "../../modules/aks"

  resource_group_name = module.resource_group.resource_group_name

  location = var.location

  project_name = var.project_name

  environment = var.environment

  cluster_name = var.cluster_name

  dns_prefix = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  node_count = var.node_count

  vm_size = var.vm_size

  log_analytics_workspace_id = module.log_analytics.workspace_id
}

module "identity" {

  source = "../../modules/identity"

  acr_id = module.acr.acr_id

  kubelet_identity = module.aks.kubelet_identity
}

module "storage" {

  source = "../../modules/storage"

  resource_group_name = module.resource_group.resource_group_name

  location = var.location

  project_name = var.project_name

  environment = var.environment

  storage_account_name = var.storage_account_name

  account_tier = var.account_tier

  account_replication_type = var.account_replication_type

  container_name = var.storage_container_name
}

module "keyvault" {

  source = "../../modules/keyvault"

  resource_group_name = module.resource_group.resource_group_name

  location = var.location

  project_name = var.project_name

  environment = var.environment

  key_vault_name = var.key_vault_name

  tenant_id = var.tenant_id
}

module "monitoring" {

  source = "../../modules/monitoring"

  aks_id = module.aks.cluster_id

  acr_id = module.acr.acr_id

  key_vault_id = module.keyvault.key_vault_id

  storage_account_id = module.storage.storage_account_id

  log_analytics_workspace_id = module.log_analytics.workspace_id
}
