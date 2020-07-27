# environment
variable "environment" {
    type        = string
    description = "The environment to be built"
    default     = "dev"
}

# azure vm region
variable "location" {
    type        = string
    description = "Azure region where the resources will be created"
    default     = "north europe" # "germanywestcentral"
}

# application name 
variable "app_name" {
    type        = string
}

# Azure virtual machine settings #
variable "win-vm-size" {
    type        = string
    description = "Size (SKU) of the virtual machine to create"
    default     = "Standard_F2"
}

variable "win-license-type" {
    type        = string
    description = "Specifies the BYOL type for the virtual machine."
    default     = null
}

# Azure virtual machine storage settings #
variable "win-delete-os-disk-on-termination" {
    type        = string
    description = "Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed?"
    default     = "true"  # Update for your environment
}

variable "win-delete-data-disks-on-termination" {
    description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed?"
    type        = string
    default     = "true" # Update for your environment
}

variable "win-vm-image" {
    type        = map(string)
    description = "Virtual machine source image information"
    default     = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }
}

# Azure virtual machine OS profile #
variable "win-admin-username" {
    type        = string
    description = "Username for Virtual Machine administrator account"
    default     = "azureuser"
}

variable "win-admin-password" {
    type        = string
    description = "Password for Virtual Machine administrator account"
    default     = "fljghslhgslgjhlkgjdh234923469djhdjshgksdjgh!@#A"
}

variable "storage_account_type" {
    type        = string
    description = "The storage account type for the Managed Disk"
    default     = "Standard_LRS"
}

variable "managed_disk_size_gb" {
    type        = list
    description = "The size of the Managed Disk in gigabytes"
    default     = [5]
}

variable "win-vm-prefix" {
    default = "example"
}

variable "azurerm_storage_account_tier" {
    type        = string
    description = "Defines the Tier to use for this storage account."
    default     = "Standard"
}

#https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy#redundancy-in-the-primary-region
variable "azurerm_account_replication_type" {
    type        = string
    description = "Data in an Azure Storage account is always replicated three times in the primary region."
    default     = "LRS"
}

variable "azurerm_storage_share_quota" {
    type        = string
    description = "The maximum size of the share, in gigabytes."
    default     = "50"
}

variable "network-subnet" {
    type        = string
}

variable "firewall_tcp_ports" {
    type        = list
    description = "list ports to allow incoming tcp connections by cloud-init"
    default     = [3389]
}

variable "firewall_udp_ports" {
    type        = list
    description = "list ports to allow incoming udp connections by cloud-init"
    default     = [3389]
}

variable "enable_automatic_updates" {
    type        = bool
    description = "list ports to allow incoming udp connections by cloud-init"
    default     = true
}

variable "shared_disk_storage_account" {
}

variable "shared_disk_name" {
    type        = string
}

variable "choco_list" {
    type        = string
    description = "list software installed by cloud-init, full list here https://chocolatey.org/packages"
    default     = ""
}
