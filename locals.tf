locals {
  resource_body = {
    managedBy = var.managed_by
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
      autoUpgradeMode         = var.auto_upgrade_mode
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
