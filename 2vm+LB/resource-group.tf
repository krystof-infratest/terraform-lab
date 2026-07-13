# resource-group.tf
data "azurerm_resource_group" "az_test_lab" {
  name = "rg-emea_we_golab-krskalik_001"
}