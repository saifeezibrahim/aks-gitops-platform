resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-${var.prefix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Free"

  # Only listed IPs can reach the Kubernetes API.
  api_server_access_profile {
    authorized_ip_ranges = var.admin_ip_cidrs
  }

  # Kubernetes RBAC on (the provider default, made explicit for reviewers and scanners).
  role_based_access_control_enabled = true

  # Needed for Microsoft Entra Workload ID: pods get Azure tokens without stored secrets.
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name           = "system"
    vm_size        = var.node_vm_size
    node_count     = var.node_count
    vnet_subnet_id = azurerm_subnet.aks.id

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "calico"
    pod_cidr            = "192.168.0.0/16"
    service_cidr        = "172.16.0.0/16"
    dns_service_ip      = "172.16.0.10"
  }

  # Secrets Store CSI driver with the Azure Key Vault provider.
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.tags
}
