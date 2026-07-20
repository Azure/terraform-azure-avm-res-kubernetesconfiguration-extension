terraform {
  required_version = ">= 1.11, < 2.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.9"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.46.0, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.12.0"

  region_filter = ["northeurope"]
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
  source  = "Azure/naming/azurerm"
  version = "0.4.3"
}

# This is required for resource modules
resource "azapi_resource" "rg" {
  location = local.location
  name     = module.naming.resource_group.name_unique
  type     = "Microsoft.Resources/resourceGroups@2025-03-01"
}

module "aks" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.6.7"

  location  = azapi_resource.rg.location
  name      = module.naming.kubernetes_cluster.name_unique
  parent_id = azapi_resource.rg.id
  default_agent_pool = {
    count_of = 1
    vm_size  = "Standard_B2s_v2"
  }
  dns_prefix = "extension-example"
  managed_identities = {
    system_assigned = true
  }
}

# This installs the Flux extension on the AKS cluster created above.
module "extension" {
  source = "../../"

  name                       = "flux"
  parent_id                  = module.aks.resource_id
  auto_upgrade_minor_version = true
  enable_telemetry           = var.enable_telemetry
  extension_type             = "microsoft.flux"
}
