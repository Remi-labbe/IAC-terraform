terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# type d'objet - "nom resource" - "identifiant resource"
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}${var.environment_suffix}"
  location = var.location
}

resource "azurerm_service_plan" "sp" {
  name                = "sp-${var.project_name}${var.environment_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "lwa" {
  name                = "lwa-${var.project_name}${var.environment_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {}
}
