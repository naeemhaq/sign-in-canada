# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "production"
  location = "Canada Central"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "production-network"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = ["10.0.0.0/16"]
  }
