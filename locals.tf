locals {
  managed_identities = {
    system_assigned_user_assigned = var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
    system_assigned = var.managed_identities.system_assigned ? {
      this = {
        type = "SystemAssigned"
      }
    } : {}
    user_assigned = length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = "UserAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
  resource_body = {
    name = var.name
    plan = var.plan == null ? null : {
      name          = var.plan.name
      product       = var.plan.product
      promotionCode = var.plan.promotion_code
      publisher     = var.plan.publisher
      version       = var.plan.version
    }
    properties = {
      aksAssignedIdentity = var.aks_assigned_identity == null ? null : {
        type = var.aks_assigned_identity.type
      }
      autoUpgradeMinorVersion = var.auto_upgrade_minor_version
      configurationSettings   = var.configuration_settings == null ? null : { for k, value in var.configuration_settings : k => value }
      extensionType           = var.extension_type
      releaseTrain            = var.release_train
      scope = var.scope == null ? null : {
        cluster = var.scope.cluster == null ? null : {
          releaseNamespace = var.scope.cluster.release_namespace
        }
        namespace = var.scope.namespace == null ? null : {
          targetNamespace = var.scope.namespace.target_namespace
        }
      }
      version = var.extension_version
    }
  }
}
