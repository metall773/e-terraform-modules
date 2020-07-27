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

variable "network-vnet-cidr" {
    type        = string
    description = "The CIDR of the network VNET"
    default     = "10.16.0.0/22"
}

variable "network-subnet-cidr" {
    type        = list
    description = "The CIDR for the network subnet"
    default     = ["10.16.1.0/24"]
}