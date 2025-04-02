# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 4.25.0"
#     }
#   }
#   backend "azurerm" {
#     resource_group_name  = "tfstate-rg"
#     storage_account_name = "tfstate-sg"
#     container_name       = "tfstate"
#     key                  = "investorflow-${terraform.workspace}.tfstate"
#   }
# }

# provider "azurerm" {
#   features {}
# }

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
    }
  }

  #   backend "azurerm" {} 
  ## local dev

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
