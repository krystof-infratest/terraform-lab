resource "azurerm_virtual_network" "lab_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = data.azurerm_resource_group.az_test_lab.location
  resource_group_name = data.azurerm_resource_group.az_test_lab.name
}

resource "azurerm_subnet" "lab_subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.az_test_lab.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = var.subnet_prefix
}