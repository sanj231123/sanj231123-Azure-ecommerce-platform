resource "azurerm_kubernetes_cluster" "this" {

  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  sku_tier = "Free"

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  automatic_upgrade_channel = "patch"
  node_os_upgrade_channel   = "NodeImage"

  default_node_pool {

    name = "system"

    vm_size = var.vm_size

    node_count = var.node_count

    os_disk_size_gb = 50

    type = "VirtualMachineScaleSets"

    auto_scaling_enabled = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {

    network_plugin = "azure"

    network_plugin_mode = "overlay"

    load_balancer_sku = "standard"
  }

  oms_agent {

    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = {

    Project     = var.project_name

    Environment = var.environment

    ManagedBy   = "Terraform"
  }
}
