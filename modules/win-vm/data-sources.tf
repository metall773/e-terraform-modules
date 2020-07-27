data "azurerm_public_ip" "public-ip" {
    depends_on          = [azurerm_public_ip.public-ip]
    name                = azurerm_public_ip.public-ip.name
    resource_group_name = azurerm_windows_virtual_machine.win_virtual_machine.resource_group_name
}