locals {
  region                        = "WestUS"
  resource_group_name           = "rgbeskardev"
  storage_account_name          = "stbeskardev55"
  app_service_plan_name         = "spbeskardev55"
  function_app_name             = "beskarfunctions"
  function_name                 = "ping"
  function_compiled_source_path = "./Beskar/bin/Release/net6.0/publish"
}

# Create a resource group for all subsequent resources
resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.region
}

# Create an Azure storage account to host the function releases, function executions and triggers
resource "azurerm_storage_account" "function_store" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a storage container for our function releases
resource "azurerm_storage_container" "function_releases" {
  name                 = "function-releases"
  storage_account_name = azurerm_storage_account.function_store.name
}

# Create a zip file of our compiled function code
data "archive_file" "function_release" {
  type        = "zip"
  source_dir  = local.function_compiled_source_path
  output_path = "function_release.zip"
}

# Upload the zip file to our storage container.
resource "azurerm_storage_blob" "function_blob" {
  # The name of the file will be "filehash.zip" where file hash is the SHA256 hash of the file.
  name                   = "${filesha256(data.archive_file.function_release.output_path)}.zip"
  source                 = data.archive_file.function_release.output_path
  storage_account_name   = azurerm_storage_account.function_store.name
  storage_container_name = azurerm_storage_container.function_releases.name
  type                   = "Block"
}

# Create an App Service plan for our function
resource "azurerm_service_plan" "this" {
  name                = local.app_service_plan_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Create our function app
resource "azurerm_linux_function_app" "this" {
  name                = local.function_app_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  enabled         = true
  service_plan_id = azurerm_service_plan.this.id

  storage_account_name          = azurerm_storage_account.function_store.name
  storage_uses_managed_identity = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "https://${azurerm_storage_account.function_store.name}.blob.core.windows.net/function-releases/${azurerm_storage_blob.function_blob.name}"
  }
}

# Allow our function's managed identity to have r/w access to the storage account
resource "azurerm_role_assignment" "function_app_to_function_releases_container_access" {
  principal_id         = azurerm_linux_function_app.this.identity[0].principal_id
  scope                = azurerm_storage_account.function_store.id
  role_definition_name = "Storage Blob Data Contributor"
}
