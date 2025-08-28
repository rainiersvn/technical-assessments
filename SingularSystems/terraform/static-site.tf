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
