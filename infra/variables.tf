variable "location" {
  type    = string
  default = "uksouth"
}

variable "app_name" {
  type    = string
  default = "investorflow"
}

variable "env_name" {
  type    = string
  default = "dev"
}

variable "domain_name" {
  type    = string
  default = "investorflow.amir.co.uk"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "vnet_address_space" {
  type        = string
  description = "CIDR block for the VNet"
}

variable "subnet_address_prefix" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "container_name" {
  type        = string
  description = "Name of the container"
  default     = "investorflow"
}
variable "domain_root" {
  type        = string
  description = "Root domain name"
}

variable "subdomain_prefix" {
  type        = string
  description = "Subdomain prefix"
  default = "investorflow"
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "resource_group_name" {
  type        = string
  description = "Existing RG to use in lab"
  default     = "kml_rg_main-f2cbcfeb382645fe" # lab environment
}
