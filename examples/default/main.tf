terraform {
  required_version = "~> 1.5"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.8"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.12.0"

  has_availability_zones = true
  is_recommended         = true
  region_name_regex      = "euap"
  region_name_regex_mode = "not_match"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azapi_resource" "rg" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
  type     = "Microsoft.Resources/resourceGroups@2025-03-01"
}

module "aks" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.5.3"

  location  = azapi_resource.rg.location
  name      = module.naming.kubernetes_cluster.name_unique
  parent_id = azapi_resource.rg.id
}

# This is the module call
module "test" {
  source = "../../"

  name = "acstor"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  parent_id                  = module.aks.resource_id
  auto_upgrade_minor_version = true
  enable_telemetry           = var.enable_telemetry
  extension_type             = "microsoft.azurecontainerstoragev2"
}
