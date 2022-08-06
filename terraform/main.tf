# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.17.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  # name     = "dev-beskar-rg"
  name     = "${var.project}${var.environment}resourcegroup"
  location = var.location

  tags = {
    Application = var.project
    Env         = var.environment
    Team        = var.team
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.project}${var.environment}storageaccount"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Application = var.project
    Env         = var.environment
    Team        = var.team
  }
}

resource "azurerm_storage_container" "blob_storage_container" {
  name                  = "${var.project}${var.environment}blobstorage"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_queue" "queue_storage" {
  name                 = "${var.project}${var.environment}queue"
  storage_account_name = azurerm_storage_account.storage_account.name
}

resource "azurerm_application_insights" "application_insights" {
  name                = "${var.project}${var.environment}appinsights"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type    = "web"
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "service_plan" {
  name                = "${var.project}${var.environment}serviceplan"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "function_app" {
  name                = "${var.project}${var.environment}functionapp"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  service_plan_id     = azurerm_service_plan.service_plan.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
  }
}




# resource "azurerm_function_app" "apis" {
#   name                      = "${var.project}func"
#   location                  = var.location
#   resource_group_name       = azurerm_resource_group.resource_group.name
#   app_service_plan_id       = azurerm_app_service_plan.app_service_plan.id
#   storage_connection_string = azurerm_storage_account.az_backend.primary_connection_string
#   https_only                = true
#   version                   = "~2"

#   app_settings = {
#     APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.ai.instrumentation_key}"
#   }

