# Create public IPs
resource "azurerm_public_ip" "public-ip" {
  name                = "${local.vm_name}-PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"
  domain_name_label   = local.vm_name

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

# Create network interface no extenalIP
resource "azurerm_network_interface" "nic" {
  name                = "${local.vm_name}-NIC"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "${local.vm_name}-NicConfiguration"
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
