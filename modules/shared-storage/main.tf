resource "random_id" "randomId-share4all" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = var.resource_group.name
  }

  byte_length = 8
}

# Create storage account for network work share for all WM 
resource "azurerm_storage_account" "storageaccount4all" {
  name                     = "4alls${random_id.randomId-share4all.hex}"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
        application = var.app_name
        environment = var.environment
  }
}

resource "azurerm_storage_share" "fileshare4all" {
  name                 = "${var.environment}-share-4-all"
  storage_account_name = azurerm_storage_account.storageaccount4all.name
  quota                = 100

  acl {
    id = random_id.randomId-share4all.hex

    access_policy {
      permissions = "rwdl"
      start       = "2019-07-02T09:38:21.0000000Z"
      expiry      = "2019-07-02T10:38:21.0000000Z"
    }
  }
}