resource "azurerm_mysql_firewall_rule" "firewall_rule" {
  name                = "${var.db-prefix}-to-mysqlserver"
  resource_group_name = var.vm_resource_group
  server_name         = azurerm_mysql_server.mysql-server.name
  start_ip_address    = var.public_ip_address
  end_ip_address      = var.public_ip_address
}