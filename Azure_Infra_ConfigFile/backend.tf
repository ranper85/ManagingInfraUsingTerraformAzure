# This file is used to configure the backend for Terraform state management. This files will be created after we created the resources in Azure Portal manually (GUI).
# https://developer.hashicorp.com/terraform/language/backend/azurerm

terraform {
     backend "azurerm" {
     resource_group_name  = "tf_state_rg"
     storage_account_name = "tfstatestorage1985"
     container_name       = "tfstatecontainer1985"
     key                  = "terraform.tfstate.file"
   }
}