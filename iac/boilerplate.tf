terraform {
  backend "azurerm" {
    resource_group_name  = "my-rg"
    storage_account_name = "mystorageaccount"
    container_name       = "tfstate"
    subscription_id      = "5555-5555-5555-5555" 
    key                  = "rust-azure-func.tfstate"
  }
}
provider "azurerm" {
  subscription_id = "5555-5555-5555-5555" 
  resource_provider_registrations = "none"
  features {}
}

data "azurerm_resource_group" "main" {
  name = "my-rg" 
}