output "fqdn" {
    value = azurerm_mysql_server.mysql-server.fqdn
}

output "username" {
    value = "${azurerm_mysql_server.mysql-server.administrator_login}@${azurerm_mysql_server.mysql-server.name}"
}