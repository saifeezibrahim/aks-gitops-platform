data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                       = "kv-${var.prefix}-${substr(md5(azurerm_resource_group.this.id), 0, 6)}"
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false # lab: lets destroy clean up fully; enable in production

  # Deny by default. Allow the AKS subnet (service endpoint) and the admin IPs.
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [azurerm_subnet.aks.id]
    ip_rules                   = var.admin_ip_cidrs
  }
  tags = var.tags
}

# Lets whoever runs Terraform create the demo secret.
resource "azurerm_role_assignment" "kv_officer_current_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "app_message" {
  name         = "app-message"
  value        = "Hello from Azure Key Vault"
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [azurerm_role_assignment.kv_officer_current_user]
}
