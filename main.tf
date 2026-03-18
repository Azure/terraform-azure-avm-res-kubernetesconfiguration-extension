resource "azapi_resource" "this" {
  name           = var.name
  parent_id      = var.parent_id
  type           = "Microsoft.KubernetesConfiguration/extensions@2024-11-01"
  body           = local.resource_body
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  response_export_values = [
    "properties.aksAssignedIdentity.principalId",
    "properties.aksAssignedIdentity.tenantId",
    "properties.currentVersion",
    "properties.customLocationSettings",
    "properties.packageUri",
  ]
  sensitive_body = var.configuration_protected_settings != null ? {
    properties = {
      configurationProtectedSettings = var.configuration_protected_settings
    }
  } : null
  sensitive_body_version = var.configuration_settings != null ? {
    "properties.configurationProtectedSettings" = var.configuraiton_protected_settings_version
  } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  dynamic "identity" {
    for_each = local.managed_identities.system_assigned_user_assigned

    content {
      type         = identity.value.type
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
}
