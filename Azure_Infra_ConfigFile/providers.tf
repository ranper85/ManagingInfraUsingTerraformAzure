# This file contains the variables used in the main.tf file.

provider "azurerm" {
  features {}

  subscription_id = "6c267e95-61b9-4029-af57-6363a1aaca09"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
  }
}
