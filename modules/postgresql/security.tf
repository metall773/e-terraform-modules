resource "azurerm_postgresql_firewall_rule" "firewall_rule" {
  name                = "${var.db-prefix}-to-postgresql"
  resource_group_name = var.vm_resource_group
  server_name         = azurerm_postgresql_server.postgresql-server.name
  start_ip_address    = var.public_ip_address
  end_ip_address      = var.public_ip_address
}