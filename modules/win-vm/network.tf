# Create public IPs
resource "azurerm_public_ip" "public-ip" {
  name                = "${local.vm_name}-PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.win-terraform-group.name
  allocation_method   = "Static"
  domain_name_label   = local.vm_name

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}


resource "azurerm_network_interface" "win_network_interface" {
  name                = "${local.vm_name}-NIC"
  location            = azurerm_resource_group.win-terraform-group.location
  resource_group_name = azurerm_resource_group.win-terraform-group.name

  ip_configuration {
    name                          = "${local.vm_name}-PrivateIP"
    subnet_id                     = var.network-subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ip.id
  }

  tags = {
    application = var.app_name
    environment = var.environment
    vm-name     = local.vm_name
  }
}