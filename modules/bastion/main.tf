#https://docs.microsoft.com/en-us/azure/bastion/bastion-overview
locals {
    bastion_name = "${var.environment}-bastion"
}

resource "azurerm_resource_group" "bastion" {
    name     = "${var.environment}-bastion"
    location = var.bastion_location
}

# Create Bastion public IP
resource "azurerm_public_ip" "bastion-public-ip" {
    name                = "${local.bastion_name}-PublicIP"
    location            = azurerm_resource_group.bastion.location
    resource_group_name = azurerm_resource_group.bastion.name
    allocation_method   = "Static"
    sku                 = "Standard"
    domain_name_label   = local.bastion_name

    tags = {
        application = var.app_name
        environment = var.environment
        name        = local.bastion_name
    }
}

# Create Bastion subnet for Network
resource "azurerm_subnet" "azure-bastion-subnet" {
    name                 = "AzureBastionSubnet"
    address_prefixes     = [var.batstion_subnet_cidr]
    virtual_network_name = var.network-vnet
    resource_group_name  = var.network-rg
}

resource "azurerm_bastion_host" "bastion-host" {
    name                = local.bastion_name
    location            = azurerm_resource_group.bastion.location
    resource_group_name = azurerm_resource_group.bastion.name

    ip_configuration {
        name                 = "${local.bastion_name}-IP-configuration"
        subnet_id            = azurerm_subnet.azure-bastion-subnet.id
        public_ip_address_id = azurerm_public_ip.bastion-public-ip.id
    }
}