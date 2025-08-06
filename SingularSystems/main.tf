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

variable "resource_group_name" {
  type    = string
  default = "trn-rg-rvanniekerk"
}

variable "storage_account_name" {
  type    = string
  default = "testdevopscodechallenge"
}

# 1. Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# 2. Storage Account
resource "azurerm_storage_account" "st" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Must allow static website
  allow_nested_items_to_be_public = true
}

# 3. Enable Static Website
resource "azurerm_storage_account_static_website" "static" {
  storage_account_id = azurerm_storage_account.st.id

  index_document     = "report.html"
  error_404_document = "report.json"
}

# 4. The $web container is implied, but Terraform needs an explicit container resource
resource "azurerm_storage_container" "web" {
  name                  = "$web"
  storage_account_id    = azurerm_storage_account.st.id
  container_access_type = "blob"
}

# 5. Upload report.html
resource "azurerm_storage_blob" "report_html" {
  name                   = "report.html"
  storage_account_name   = azurerm_storage_account.st.name
  storage_container_name = azurerm_storage_container.web.name
  type                   = "Block"

  source_content = file("${path.module}/report/report.html")
  content_type   = "text/html; charset=utf-8"
}

# 6. Upload report.json
resource "azurerm_storage_blob" "report_json" {
  name                   = "report.json"
  storage_account_name   = azurerm_storage_account.st.name
  storage_container_name = azurerm_storage_container.web.name
  type                   = "Block"

  source_content = file("${path.module}/report/report.json")
  content_type   = "application/json"
}
