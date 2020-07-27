# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "${local.vm_name}-NetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.win-terraform-group.name

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

resource "azurerm_network_security_rule" "inbound_tcp_rules" {
  count                       = length(var.firewall_tcp_ports)
  name                        = "sg-rule-tcp-${element(var.firewall_tcp_ports, count.index)}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 101 + 10 * count.index
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = element(var.firewall_tcp_ports, count.index)
  protocol                    = "TCP"
  resource_group_name         = azurerm_resource_group.win-terraform-group.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}

resource "azurerm_network_security_rule" "inbound_udp_rules" {
  count                       = length(var.firewall_udp_ports)
  name                        = "sg-rule-udp-${element(var.firewall_udp_ports, count.index)}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 202 +  10 * count.index
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = element(var.firewall_udp_ports, count.index)
  protocol                    = "UDP"
  resource_group_name         = azurerm_resource_group.win-terraform-group.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.win_network_interface.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}
