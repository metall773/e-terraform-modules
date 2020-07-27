output "public_ip_address_bastion" {
    value = data.azurerm_public_ip.bastion-public-ip.ip_address
}

output "fqdn_bastion" {
    value = data.azurerm_public_ip.bastion-public-ip.fqdn
}
