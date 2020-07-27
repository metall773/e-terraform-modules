output "public_ip_address" {
    value = data.azurerm_public_ip.public-ip.ip_address
}

output "fqdn" {
    value = data.azurerm_public_ip.public-ip.fqdn
}

output "username" { 
    value = var.win-admin-username
}

output "vm_resource_group" {
    value = azurerm_resource_group.win-terraform-group
    depends_on = [azurerm_resource_group.win-terraform-group]
}