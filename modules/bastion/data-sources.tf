data "azurerm_public_ip" "bastion-public-ip" {
    depends_on          = [azurerm_public_ip.bastion-public-ip]
    name                = azurerm_public_ip.bastion-public-ip.name
    resource_group_name = azurerm_bastion_host.bastion-host.resource_group_name
}