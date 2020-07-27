resource "azurerm_mysql_server" "mysql-server" {
  name                = "${var.db-prefix}-mysql"
  location            = var.location
  resource_group_name = var.vm_resource_group

  administrator_login          = var.admin-username
  administrator_login_password = var.admin-password

  sku_name   = var.db-size
  storage_mb = var.storage_mb
  version    = var.db-version

  auto_grow_enabled                 = var.auto_grow_enabled
  backup_retention_days             = var.backup_retention_days
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = var.public_network_access_enabled
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  tags = {
    application = var.app_name
    environment = var.environment
    vm-name     = var.vm_resource_group
  }
}

# Create a MySQL Database
resource "azurerm_mysql_database" "mysql-db" {
  name                = var.database_name
  resource_group_name = var.vm_resource_group
  server_name         = azurerm_mysql_server.mysql-server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}