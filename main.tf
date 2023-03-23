terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.48.0"
    }
  }
  backend "azurerm" {

  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_mssql_server" "sqlsrv" {
  name                         = "sqlsrv-${var.project_name}${var.environment_suffix}"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = data.azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.db-login.value
  administrator_login_password = data.azurerm_key_vault_secret.db-password.value
}

resource "azurerm_mssql_database" "sql-db" {
  name           = "RabbitMqDemo"
  server_id      = azurerm_mssql_server.sqlsrv.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    foo = "bar"
  }
}

resource "azurerm_service_plan" "sp" {
  name                = "sp-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "lwa" {
  name                = "lwa-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {}

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.sqlsrv.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sql-db.name};Persist Security Info=False;User ID=${data.azurerm_key_vault_secret.db-login.value};Password=${data.azurerm_key_vault_secret.db-password.value};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  app_settings = {
    RabbitMQ__Hostname = "rabbitmq"
    RabbitMQ__Username = data.azurerm_key_vault_secret.rabbitmq-login.value
    RabbitMQ__Password = data.azurerm_key_vault_secret.rabbitmq-password.value
  }
}
