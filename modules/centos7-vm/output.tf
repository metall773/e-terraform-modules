output "public_ip_address" {
    description = "VM's public ip address"
    value       = data.azurerm_public_ip.public-ip.ip_address
}

output "fqdn" {
    description = "VM's fully qualified domain name"
    value       = data.azurerm_public_ip.public-ip.fqdn
}

output "username" {
    description = "The name of user with permissions to make ssh login"
    value = var.web-linux-admin-username
}

output "vm_resource_group" {
    description = "VM resource group name"
    value = azurerm_resource_group.myterraformgroup
    depends_on = [azurerm_resource_group.myterraformgroup]
}