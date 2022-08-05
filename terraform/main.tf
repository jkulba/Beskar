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
  name     = "${var.environment}${var.project}rg"
  location = var.location

  tags = {
    Application = "Beskar"
    Env         = var.environment
    Team        = "Engineering"
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.environment}${var.project}st"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_insights" "application_insights" {
  name                = "${var.environment}${var.project}ai"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type    = "web"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "${var.environment}${var.project}sp"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
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

