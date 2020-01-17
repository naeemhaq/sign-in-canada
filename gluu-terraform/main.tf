# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "production"
  location = "West US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "production-network"
  resource_group_name = "${azurerm_resource_group.example.name}"
  location            = "${azurerm_resource_group.example.location}"
  address_space       = ["10.0.0.0/16"]
