data "azurerm_public_ip" "public-ip" {
    depends_on          = [azurerm_public_ip.public-ip]
    name                = azurerm_public_ip.public-ip.name
    resource_group_name = azurerm_linux_virtual_machine.myterraformvm.resource_group_name
}