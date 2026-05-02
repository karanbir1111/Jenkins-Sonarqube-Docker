terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatedd9xg5"
    container_name       = "tfstate"
    key                  = "network/terraform.tfstate"
  }
}

