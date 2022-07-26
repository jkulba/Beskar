# Terraform Configuration
terraform {
  # Terraform's Version Constraint
  required_version = "~> 1.2.5"

  # Providers Version Constraints
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}

# Azure Provider Configuration
provider "azurerm" {
  features {}
}
