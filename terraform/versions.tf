terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
  }

  # Local state keeps the lab simple. For team use, switch to the azurerm backend
  # (Storage Account + container) so state is shared and locked.
}

provider "azurerm" {
  # Subscription comes from the ARM_SUBSCRIPTION_ID environment variable.
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
