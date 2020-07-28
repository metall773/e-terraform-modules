output "public_ip_address" {
    value = data.azurerm_public_ip.public-ip.ip_address
}

output "fqdn" {
    value = data.azurerm_public_ip.public-ip.fqdn
}

output "username" { 
    value = var.web-linux-admin-username
}

output "vm_resource_group" {
    value = azurerm_resource_group.myterraformgroup
    depends_on = [azurerm_resource_group.myterraformgroup]
}