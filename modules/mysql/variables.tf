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

variable "vm_resource_group" {
    type    = any
    default = []
    description = "Name of azure vitral machine resource group"
}

# Azure DB cred
variable "admin-username" {
    type        = string
    description = "Username for DB administrator account"
    default     = "azureuser"
}

variable "admin-password" {
    type        = string
    description = "Password for DB administrator account"
    default     = "LKGJHkjdhgkljbnuueu1321204870dogojbicjboijb"
}

#DB size
#https://docs.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-single-databases
variable "db-size" {
    type        = string
    description = "Size (SKU) of the db to create"
    default     = "B_Gen5_2"
}

variable "db-version" {
    default = "5.7"
}

#DB variables
variable "db-prefix" {
    default = "example"
}

variable "backup_retention_days" {
    default = 7
}

variable "storage_mb" {
    default = 5120
}

variable "geo_redundant_backup_enabled" {
    default = false
}

variable "public_network_access_enabled" {
    default = false
}

variable "auto_grow_enabled" {
    default = true
}

variable "public_ip_address" {
    type    = string
}

variable "database_name" {
    type    = string
}
