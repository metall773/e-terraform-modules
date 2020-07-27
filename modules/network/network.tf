# Create the network VNET
resource "azurerm_virtual_network" "network-vnet" {
    name                = "${var.environment}-vnet"
    address_space       = [var.network-vnet-cidr]
    resource_group_name = var.resource_group.name
    location            = var.resource_group.location
    tags = {
        application = var.app_name
        environment = var.environment
    }
}

# Create a subnet for Network
resource "azurerm_subnet" "network-subnet" {
    name                 = "${var.environment}-subnet"
    address_prefixes     = var.network-subnet-cidr
    virtual_network_name = azurerm_virtual_network.network-vnet.name
    resource_group_name  = var.resource_group
}