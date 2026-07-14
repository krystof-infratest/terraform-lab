# string generator
resource "random_id" "vault_suffix" {
  byte_length = 4
}

# LAworkspace
resource "azurerm_log_analytics_workspace" "security_workspace" {
  name                = "${var.environment_prefix}-law-${random_id.vault_suffix.hex}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.az_test_lab.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# SA
resource "azurerm_storage_account" "secure_vault" {
  name                     = "auditvault${random_id.vault_suffix.hex}"
  resource_group_name      = "rg-emea_we_golab-krskalik_001"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true

  # Account-level foundation to unlock WORM capabilities
  immutability_policy {
    allow_protected_append_writes = true
    state                         = "Unlocked"
    period_since_creation_in_days = 7
  }
}

# container
resource "azurerm_storage_container" "audit_container" {
  name                  = "sensitive-logs-vault"
  storage_account_name  = azurerm_storage_account.secure_vault.name
  container_access_type = "private"
}

# policy 
resource "azurerm_storage_management_policy" "immutability_rule" {
  storage_account_id = azurerm_storage_account.secure_vault.id

  rule {
    name    = "WORM_Retention_Policy"
    enabled = true
    filters {
      prefix_match = [azurerm_storage_container.audit_container.name]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = var.retention_days
      }
    }
  }
}

# DS
resource "azurerm_monitor_diagnostic_setting" "storage_audit_trail" {
  name                       = "stream-blob-access-audit-logs"
  target_resource_id         = "${azurerm_storage_account.secure_vault.id}/blobServices/default"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.security_workspace.id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }
}

# Strict container immutability lock mapping
resource "azurerm_storage_container_immutability_policy" "strict_worm_lock" {
  storage_container_resource_manager_id = azurerm_storage_container.audit_container.resource_manager_id
  immutability_period_in_days           = var.retention_days
  protected_append_writes_enabled       = true

  depends_on = [
    azurerm_storage_container.audit_container
  ]
}
