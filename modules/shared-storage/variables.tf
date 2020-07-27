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

variable "resource_group" {
    type    = any
    default = []
    description = "Name of azure resource group for network"
}