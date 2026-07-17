resource "azapi_resource" "this" {
  name                 = var.name
  parent_id            = var.parent_id
  type                 = "Microsoft.KubernetesConfiguration/extensions@2025-03-01"
  body                 = local.resource_body
  create_headers       = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers       = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  ignore_null_property = true
  read_headers         = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  response_export_values = [
    "properties.aksAssignedIdentity.principalId",
    "properties.aksAssignedIdentity.tenantId",
    "properties.extensionState",
    "properties.currentVersion",
    "properties.customLocationSettings",
    "properties.errorInfo",
    "properties.isSystemExtension",
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
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  dynamic "identity" {
    for_each = var.managed_identities.system_assigned ? [1] : []

    content {
      type = "SystemAssigned"
    }
  }
}
