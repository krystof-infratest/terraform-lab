terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id            = "cc6a730c-166e-4962-aa29-0e4b0f741ecf"
  skip_provider_registration = true
}