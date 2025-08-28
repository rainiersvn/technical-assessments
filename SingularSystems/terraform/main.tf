# The goal is to test the candidates ability to R&D, they will be given AzureRM Terraform resource names to use:
# azurerm_resource_group, azurerm_storage_account, azurerm_storage_account_static_website, azurerm_storage_container, azurerm_storage_blob
# They MUST use the above resources (if Building in Azure), I.E from the resource group down all resources must be terraform managed.
# If they want they can use other clouds like AWS/GCP but the same philosophy  will apply, they must use the equivalent resources in that cloud.
# On-top of this they must do a write up of how we should configure and run their terraform code to re-produce what they have built in our Infrastructure.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "74da9000-9b4f-46d9-856f-1052beecbf85"
}
