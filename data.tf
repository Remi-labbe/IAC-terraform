data "azurerm_resource_group" "rg" {
  name = "rg-${var.project_name}${var.environment_suffix}"
}

data "azurerm_key_vault" "kv" {
  name = "kv-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault_secret" "db-login" {
  name = "database-login"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "db-password" {
  name = "database-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "rabbitmq-login" {
  name = "rabbitmq-login"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "rabbitmq-password" {
  name = "rabbitmq-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}
