locals {
  vm_name = "${var.environment}-${var.win-vm-prefix}-vm"
}

resource "azurerm_resource_group" "win-terraform-group" {
  name     = local.vm_name
  location = var.location

  tags = {
    application = var.app_name
    environment = var.environment
    vm-name     = local.vm_name
  }
}

resource "azurerm_windows_virtual_machine" "win_virtual_machine" {
  name                     = local.vm_name
  resource_group_name      = azurerm_resource_group.win-terraform-group.name
  location                 = azurerm_resource_group.win-terraform-group.location
  size                     = var.win-vm-size
  admin_username           = var.win-admin-username
  admin_password           = var.win-admin-password
  computer_name            = local.vm_name
  enable_automatic_updates = var.enable_automatic_updates
  provision_vm_agent       = true
  network_interface_ids    = [
    azurerm_network_interface.win_network_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    offer     = lookup(var.win-vm-image, "offer", null)
    publisher = lookup(var.win-vm-image, "publisher", null)
    sku       = lookup(var.win-vm-image, "sku", null)
    version   = lookup(var.win-vm-image, "version", null)
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  
  tags = {
    application = var.app_name
    environment = var.environment
    vm-name     = local.vm_name
  }
}