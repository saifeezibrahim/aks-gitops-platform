# Identity the sample app uses to read Key Vault. No client secret exists anywhere:
# AKS issues a service account token, Entra ID trusts it through the federated credential.
resource "azurerm_user_assigned_identity" "sample_app" {
  name                = "id-${var.prefix}-sample-app"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "sample_app" {
  name                = "sample-app"
  resource_group_name = azurerm_resource_group.this.name
  parent_id           = azurerm_user_assigned_identity.sample_app.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.this.oidc_issuer_url
  subject             = "system:serviceaccount:${var.app_namespace}:sample-app"
}

# Read-only access to secrets, nothing else.
resource "azurerm_role_assignment" "kv_reader_sample_app" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.sample_app.principal_id
}
