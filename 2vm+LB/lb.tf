resource "azurerm_lb" "lab_lb" {
  name                = "lb-lab-core"
  location            = data.azurerm_resource_group.az_test_lab.location
  resource_group_name = data.azurerm_resource_group.az_test_lab.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontend"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.lb_private_ip
  }
}

resource "azurerm_lb_backend_address_pool" "lb_pool" {
  name            = "BackendAddressPool"
  loadbalancer_id = azurerm_lb.lab_lb.id
}

resource "azurerm_lb_probe" "lb_probe" {
  name            = "http-health-probe"
  loadbalancer_id = azurerm_lb.lab_lb.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lab_lb.id
  name                           = "HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}