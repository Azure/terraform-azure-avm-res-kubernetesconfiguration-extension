mock_provider "azapi" {}
mock_provider "modtm" {}
mock_provider "random" {}

variables {
  configuration_protected_settings = {}
  extension_type                   = "microsoft.flux"
  name                             = "flux"
  parent_id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ContainerService/managedClusters/aks-test"
}

run "default_configuration" {
  command = apply

  assert {
    condition     = azapi_resource.this.type == "Microsoft.KubernetesConfiguration/extensions@2025-03-01"
    error_message = "The extension must use the latest stable ARM API version."
  }

  assert {
    condition     = azapi_resource.this.body.properties.extensionType == "microsoft.flux"
    error_message = "The extension type must be passed to the AzAPI body."
  }
}

run "complete_configuration" {
  command = apply

  variables {
    aks_assigned_identity = {
      type = "Workload"
    }
    auto_upgrade_mode          = "compatible"
    auto_upgrade_minor_version = true
    configuration_settings = {
      "helm-controller.enabled" = "true"
    }
    managed_by = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test"
    managed_identities = {
      system_assigned = true
    }
    release_train = "Stable"
    scope = {
      cluster = {
        release_namespace = "flux-system"
      }
    }
  }

  assert {
    condition     = azapi_resource.this.body.properties.aksAssignedIdentity.type == "Workload"
    error_message = "AKS assigned identity configuration must be passed to AzAPI."
  }

  assert {
    condition     = azapi_resource.this.body.properties.autoUpgradeMode == "compatible"
    error_message = "Auto-upgrade mode must be passed to AzAPI."
  }

  assert {
    condition     = !can(azapi_resource.this.body.properties.additionalDetails) && !can(azapi_resource.this.body.properties.managementDetails) && !can(azapi_resource.this.body.properties.statuses)
    error_message = "Read-only response properties must not be passed to AzAPI."
  }

  assert {
    condition     = length(keys(azapi_resource.this.body.properties.aksAssignedIdentity)) == 1
    error_message = "Only the writable AKS assigned identity type may be passed to AzAPI."
  }
}
