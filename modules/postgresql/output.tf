output "fqdn" {
    value = azurerm_postgresql_server.postgresql-server.fqdn
}

output "username" {
    value = "${azurerm_postgresql_server.postgresql-server.administrator_login}@${azurerm_postgresql_server.postgresql-server.name}"
}