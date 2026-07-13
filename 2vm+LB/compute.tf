resource "azurerm_network_interface" "vm_nics" {
  count               = length(var.vm_names)
  name                = "nic-${var.vm_names[count.index]}"
  location            = data.azurerm_resource_group.az_test_lab.location
  resource_group_name = data.azurerm_resource_group.az_test_lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_pool_assoc" {
  count                   = length(var.vm_names)
  network_interface_id    = azurerm_network_interface.vm_nics[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_pool.id
}

resource "azurerm_windows_virtual_machine" "lab_vms" {
  count               = length(var.vm_names)
  name                = var.vm_names[count.index]
  resource_group_name = data.azurerm_resource_group.az_test_lab.name
  location            = data.azurerm_resource_group.az_test_lab.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.vm_nics[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" # Kept simple for B2s limitations
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-Datacenter" # Windows Server 2025 Datacenter Edition
    version   = "latest"
  }
}