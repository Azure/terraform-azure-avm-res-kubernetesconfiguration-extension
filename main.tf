resource "azapi_resource" "this" {
  name                 = var.name
  parent_id            = var.parent_id
  type                 = "Microsoft.KubernetesConfiguration/extensions@2025-03-01"
  body                 = local.resource_body
  ignore_null_property = true
  response_export_values = [
    "properties.additionalDetails",
    "properties.aksAssignedIdentity.clientId",
    "properties.aksAssignedIdentity.objectId",
    "properties.aksAssignedIdentity.principalId",
    "properties.aksAssignedIdentity.resourceId",
    "properties.aksAssignedIdentity.tenantId",
    "properties.extensionState",
    "properties.currentVersion",
    "properties.customLocationSettings",
    "properties.errorInfo",
    "properties.isSystemExtension",
    "properties.managementDetails",
    "properties.packageUri",
    "properties.provisioningState",
    "properties.statuses",
  ]
  sensitive_body = var.configuration_protected_settings != null ? {
    properties = {
      configurationProtectedSettings = var.configuration_protected_settings
    }
  } : null
  sensitive_body_version = var.configuration_protected_settings_version != null ? {
    "properties.configurationProtectedSettings" = var.configuration_protected_settings_version
  } : null

  dynamic "identity" {
    for_each = var.managed_identities.system_assigned ? [1] : []

    content {
      type = "SystemAssigned"
    }
  }
}
