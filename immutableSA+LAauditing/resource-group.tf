# resource-group.tf
data "azurerm_resource_group" "az_test_lab" {
  name = "insert_rg"
}