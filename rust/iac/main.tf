resource "azurerm_service_plan" "main" {
  name                = "rust-azure-func-plan"
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = data.azurerm_resource_group.main.tags
  location            = data.azurerm_resource_group.main.location
  os_type             = "Linux"
  
  # flex consumption not available in canada yet
  # az functionapp list-flexconsumption-locations --output table
  # https://learn.microsoft.com/en-us/azure/azure-functions/flex-consumption-how-to?tabs=azure-cli%2Cvs-code-publish&pivots=programming-language-csharp#view-currently-supported-regions
  # sku_name            = "FC1"

  sku_name = "Y1"
}

resource "azurerm_storage_account" "main" {
  name                     = "myrustazurefunc"
  resource_group_name      = data.azurerm_resource_group.main.name
  tags                     = data.azurerm_resource_group.main.tags
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_function_app" "main" {
  name                = "rust-azure-func"
  location            = data.azurerm_resource_group.main.location
  tags                = data.azurerm_resource_group.main.tags
  resource_group_name = data.azurerm_resource_group.main.name

  service_plan_id = azurerm_service_plan.main.id

  # storage_uses_managed_identity = true
  # this makes deployment a pain in the ass
  # https://github.com/microsoft/vscode-azurefunctions/issues/3657
  # will use storage key instead
  # (to deploy we need to uplaod to the storage account?)
  # (on our laptop we aren't authenticated using the managed identity since its a laptop not the fn app)

  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  storage_account_name          = azurerm_storage_account.main.name
  site_config {
    application_stack {
      use_custom_runtime = true
    }
    cors {
      allowed_origins = [
        "https://portal.azure.com"
      ]
      support_credentials = false
    }
  }
  lifecycle {
    ignore_changes = [ app_settings["WEBSITE_RUN_FROM_PACKAGE"] ]
  }
}
