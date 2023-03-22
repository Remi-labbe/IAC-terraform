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
  name     = "rg-rlabbe"
  location = "West Europe"
}
