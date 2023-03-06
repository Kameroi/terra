# https://hub.docker.com/r/bitnami/wordpress
resource "kubernetes_deployment" "kube-wp" {
  depends_on = [
    kubernetes_persistent_volume_claim.wp-content
  ]
  metadata {
    name = "kube-wp"
  }
  spec {
    progress_deadline_seconds = 180
    replicas = 2
    selector {
      match_labels = {
        app = "kube-wp"
      }
    }
    template {
      metadata {
        labels = {
          app = "kube-wp"
        }
      }
      spec {
        volume {
          name = "wp-content"
          persistent_volume_claim {
            claim_name = "wp-content-pvc"
          }
        }
        container {
          name  = "kube-wp"
          image = "bitnami/wordpress:latest"
          volume_mount {
            name       = "wp-content"
            mount_path = "/opt/bitnami/wordpress/wp-content/"
          }
          port {
            container_port = 8080
          }
          env {
            name  = "WORDPRESS_DATABASE_HOST"
            value = data.terraform_remote_state.state.outputs.aurora_cluster_endpoint
          }
          env { # check, idk
            name  = "WORDPRESS_DATABASE_USER"
            value = "masteruser"
          }
          env {
            name  = "WORDPRESS_DATABASE_PASSWORD"
            value = "notsecretpwd9"
          }

          env {
            name  = "WORDPRESS_DATABASE_PORT_NUMBER"
            value = 3306
          }

          env {
            name  = "WORDPRESS_DATABASE_NAME"
            value = var.db_name
          }
          # In case the database already contains data from a previous WordPress 
          # installation, you need to set the variable WORDPRESS_SKIP_BOOTSTRAP to yes
          env {
            name  = "WORDPRESS_SKIP_BOOTSTRAP"
            value = "yes"
          }
          env {
            name  = "WORDPRESS_DATA_TO_PERSIST"
            value = "wp-config.php"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kube-wp" {
  metadata {
    name = "kube-wp"
  }
  spec {
    selector = {
      app = "kube-wp"
      #or app = kubernetes_deployment.wordpress.metadata.0.labels.app
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "NodePort"
  }
}
