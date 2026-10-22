terraform {
  required_version = ">= 1.11, < 2.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.13.0"

  location         = var.location
  enable_telemetry = var.enable_telemetry
  region_filter    = ["northeurope"]
}

resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

locals {
  location = module.regions.regions[random_integer.region_index.result].name
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/avm-utl-naming/azure"
  version = "0.2.0"
}

# This is required for resource modules
resource "azapi_resource" "rg" {
  location = local.location
  name     = module.naming.resource_group.name_unique
  type     = "Microsoft.Resources/resourceGroups@2025-03-01"
}

module "aks" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.8.4"

  location  = azapi_resource.rg.location
  name      = module.naming.kubernetes_cluster.name_unique
  parent_id = azapi_resource.rg.id
  default_agent_pool = {
    count_of = 1
    vm_size  = "Standard_B2s_v2"
  }
  dns_prefix       = "extension-example"
  enable_telemetry = var.enable_telemetry
  managed_identities = {
    system_assigned = true
  }
}

# Wait for all managed cluster operations, including the default agent pool update,
# before installing an extension that can initiate another AKS operation.
module "extension" {
  source = "../../"

  extension_type             = "microsoft.flux"
  location                   = var.location
  name                       = "flux"
  parent_id                  = module.aks.resource_id
  auto_upgrade_minor_version = true
  enable_telemetry           = var.enable_telemetry

  depends_on = [module.aks]
}
