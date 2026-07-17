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
        clientId   = var.aks_assigned_identity.client_id
        objectId   = var.aks_assigned_identity.object_id
        resourceId = var.aks_assigned_identity.resource_id
        type       = var.aks_assigned_identity.type
      }
      additionalDetails = var.additional_details == null ? null : {
        docs                 = var.additional_details.docs
        releaseNotes         = var.additional_details.release_notes
        troubleshootingGuide = var.additional_details.troubleshooting_guide
      }
      autoUpgradeMode         = var.auto_upgrade_mode
      autoUpgradeMinorVersion = var.auto_upgrade_minor_version
      configurationSettings   = var.configuration_settings == null ? null : { for k, value in var.configuration_settings : k => value }
      extensionType           = var.extension_type
      managementDetails = var.management_details == null ? null : {
        accessDetails = var.management_details.access_details == null ? null : [
          for detail in var.management_details.access_details : {
            allowedActions = detail.allowed_actions
            description    = detail.description
            entity         = detail.entity
          }
        ]
        category = var.management_details.category
      }
      releaseTrain = var.release_train
      scope = var.scope == null ? null : {
        cluster = var.scope.cluster == null ? null : {
          releaseNamespace = var.scope.cluster.release_namespace
        }
        namespace = var.scope.namespace == null ? null : {
          targetNamespace = var.scope.namespace.target_namespace
        }
      }
      statuses = var.statuses == null ? null : [
        for status in var.statuses : {
          code          = status.code
          displayStatus = status.display_status
          level         = status.level
          message       = status.message
          time          = status.time
        }
      ]
      version = var.extension_version
    }
  }
}
