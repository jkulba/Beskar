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
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Application = var.project
    Env         = var.environment
    Team        = var.team
  }
}

# resource "azurerm_storage_queue" "queue_storage" {
#   name                 = "${var.project}${var.environment}queue"
#   storage_account_name = azurerm_storage_account.storage_account.name
# }

# Create Application Insights Monitoring
resource "azurerm_application_insights" "application_insights" {
  name                = "${var.project}${var.environment}appinsights"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type    = "web"

  tags = {
    Application = var.project
    Env         = var.environment
    Team        = var.team
    Monitoring  = "BeskarFunctionApp"
  }
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "service_plan" {
  name                = "${var.project}${var.environment}serviceplan"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Create Linux Function App
resource "azurerm_linux_function_app" "function_app" {
  name                 = "${var.project}${var.environment}functionapp"
  resource_group_name  = azurerm_resource_group.resource_group.name
  location             = azurerm_resource_group.resource_group.location
  storage_account_name = azurerm_storage_account.storage_account.name
  service_plan_id      = azurerm_service_plan.service_plan.id
  https_only           = true
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"       = 1
    "FUNCTIONS_WORKER_RUNTIME"       = "dotnet"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.application_insights.instrumentation_key}"
    # "APPLICATIONINSIGHTS_CONNECTION_STRING" = "InstumentationKey="
  }

  site_config {
    minimum_tls_version = "1.2"
  }
}


# resource "azurerm_linux_web_app_slot" "function_app_slot" {
#   name           = "${var.project}${var.environment}slot"
#   app_service_id = azurerm_linux_web_app.function_app.id

#   site_config {}
# }
