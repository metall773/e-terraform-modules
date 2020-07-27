# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.myterraformgroup.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

# Create storage account for network share
resource "azurerm_storage_account" "mystorageaccount-files" {
  name                     = "files${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = var.location
  account_tier             = var.azurerm_storage_account_tier
  account_replication_type = var.azurerm_account_replication_type

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

resource "azurerm_storage_share" "myfileshare" {
  name                 = "${local.vm_name}-files-share"
  storage_account_name = azurerm_storage_account.mystorageaccount-files.name
  quota                = var.azurerm_storage_share_quota

  acl {
    id = "${random_id.randomId.hex}MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

    access_policy {
      permissions = "rwdl"
      start       = "2019-07-02T09:38:21.0000000Z"
      expiry      = "2019-07-02T10:38:21.0000000Z"
    }
  }
}

# data disk
resource "azurerm_managed_disk" "linux-vm-managed_disk" {
  name                 = "${local.vm_name}-managed-data-disk"
  location             = azurerm_resource_group.myterraformgroup.location
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  os_type              = "Linux"
  disk_size_gb         = var.managed_disk_size_gb
      tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
    }
}

resource "azurerm_virtual_machine_data_disk_attachment" "linux-vm-managed_disk" {
  virtual_machine_id = azurerm_linux_virtual_machine.myterraformvm.id
  managed_disk_id    = azurerm_managed_disk.linux-vm-managed_disk.id
  lun                = 1
  caching            = "None"
}