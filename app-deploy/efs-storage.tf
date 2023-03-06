# https://kubernetes.io/docs/concepts/storage/storage-classes/
# Storage Class is needed for Persistent Volume
# to be dynamically provisioned
resource "kubernetes_storage_class" "efs-sc" {
  metadata {
    name = "efs-sc"
  }
  #mount_options = "tls"
  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    # https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/examples/kubernetes/dynamic_provisioning
    # The type of volume to be provisioned by efs
    # Currently, only access point based provisioning is supported - efs-ap
    provisioningMode = "efs-ap"
    fileSystemId     = data.terraform_remote_state.state.outputs.efs_file_system_id
    directoryPerms   = "755"    
  }
  # Waits for csi driver to be deployed
  depends_on = [
    helm_release.aws-efs-csi-driver
  ]
}

resource "kubernetes_persistent_volume_claim" "wp-content" {
  metadata {
    name = "wp-content-pvc"
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "efs-sc"
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
  depends_on = [
    helm_release.aws-efs-csi-driver
  ]
}
