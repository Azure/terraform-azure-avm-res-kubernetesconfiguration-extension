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
    additional_details = {
      docs                  = "https://example.com/docs"
      release_notes         = "https://example.com/releases"
      troubleshooting_guide = "https://example.com/troubleshooting"
    }
    aks_assigned_identity = {
      client_id   = "00000000-0000-0000-0000-000000000001"
      object_id   = "00000000-0000-0000-0000-000000000002"
      resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/extension"
      type        = "Workload"
    }
    auto_upgrade_mode          = "compatible"
    auto_upgrade_minor_version = true
    configuration_settings = {
      "helm-controller.enabled" = "true"
    }
    managed_by = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test"
    management_details = {
      access_details = [{
        allowed_actions = ["Microsoft.KubernetesConfiguration/extensions/read"]
        description     = "Publisher access"
        entity          = "publisher"
      }]
      category = "publisher"
    }
    managed_identities = {
      system_assigned = true
    }
    release_train = "Stable"
    scope = {
      cluster = {
        release_namespace = "flux-system"
      }
    }
    statuses = [{
      code           = "Ready"
      display_status = "Ready"
      level          = "Information"
      message        = "Extension is ready."
      time           = "2026-07-17T00:00:00Z"
    }]
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
    condition     = azapi_resource.this.body.properties.additionalDetails.docs == "https://example.com/docs"
    error_message = "Publisher details must be passed to AzAPI."
  }
}
