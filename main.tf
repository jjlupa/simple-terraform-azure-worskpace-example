terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.51.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
  }
}

resource "azurerm_resource_group" "workspace-sample-rg" {
  name     = "terraform-workspace-sample"
  location = local.workspace["location"]
}
