provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false  # Prevents purging soft-deleted Key Vaults upon destruction
    }
  }
  subscription_id = "dade8d7a-5cd1-4b8e-8010-de3fdc42adbb"
   version = "=4.14.0"  # Locks the provider to version 4.14.0
}
