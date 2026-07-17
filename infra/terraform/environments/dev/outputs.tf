output "resource_group_name" {
  value = module.resource_group.resource_group_name
}

output "resource_group_id" {
  value = module.resource_group.resource_group_id
}

output "acr_name" {
  value = module.acr.acr_name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "log_analytics_workspace_name" {
  value = module.log_analytics.workspace_name
}

output "log_analytics_workspace_id" {
  value = module.log_analytics.workspace_id
}

output "aks_cluster_name" {

  value = module.aks.cluster_name
}

output "aks_cluster_id" {

  value = module.aks.cluster_id
}

output "acr_pull_role_assignment" {
  value = module.identity.role_assignment_id
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "storage_container_name" {
  value = module.storage.container_name
}

output "storage_blob_endpoint" {
  value = module.storage.primary_blob_endpoint
}

output "key_vault_name" {
  value = module.keyvault.key_vault_name
}

output "key_vault_id" {
  value = module.keyvault.key_vault_id
}

output "key_vault_uri" {
  value = module.keyvault.vault_uri
}

output "monitoring_enabled" {

  value = module.monitoring.monitoring_enabled
}
