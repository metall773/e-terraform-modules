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
variable "web-linux-vm-size" {
    type        = string
    description = "Size (SKU) of the virtual machine to create"
    default     = "Standard_B1ls"
}

variable "web-linux-license-type" {
    type        = string
    description = "Specifies the BYOL type for the virtual machine."
    default     = null
}

# Azure virtual machine storage settings #
variable "web-linux-delete-os-disk-on-termination" {
    type        = string
    description = "Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed?"
    default     = "true"  # Update for your environment
}

variable "web-linux-delete-data-disks-on-termination" {
    description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed?"
    type        = string
    default     = "true" # Update for your environment
}

variable "web-linux-vm-image" {
    type        = map(string)
    description = "Virtual machine source image information"
    default     = {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7_8"
        version   = "latest"
    }
}

# Azure virtual machine OS profile #
variable "web-linux-admin-username" {
    type        = string
    description = "Username for Virtual Machine administrator account"
    default     = "azureuser"
}

variable "storage_account_type" {
    type        = string
    description = "The storage account type for the Managed Disk"
    default     = "Standard_LRS"
}

variable "managed_disk_size_gb" {
    type        = string
    description = "The size of the Managed Disk in gigabytes"
    default     = "5"
}

variable "managed_disk_mount_point" {
    type        = string
    description = "path for mount managed disk"
    default     = "/home/bitrix"
}

variable "web-linux-vm-prefix" {
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

variable "install_bitrix" {
    type        = string
    description = "Install bitrix by cloud-init"
    default     = "yes"
}

variable "install_autoupdate" {
    type        = string
    description = "Install autoupdate by cloud-init"
    default     = "yes"
}

variable "install_fail2ban" {
    type        = string
    description = "Install fail2ban by cloud-init"
    default     = "yes"
}

variable "firewall_tcp_ports" {
    type        = list
    description = "list ports to allow incoming tcp connections by cloud-init"
    default     = [22]
}

variable "firewall_udp_ports" {
    type        = list
    description = "list ports to allow incoming udp connections by cloud-init"
    default     = []
}

variable "enable_extenalIP" {
    description = "If set to true, add external IP"
    type        = bool
    default     = true
}

variable "shared_disk_storage_account" {
}

variable "shared_disk_name" {
    type        = string
}