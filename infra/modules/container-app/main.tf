resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.rg_name
  container_app_environment_id = var.container_env_id
  revision_mode                = "Single"

  secret {
    name  = "acr-password"
    value = var.acr_credentials.password
  }

  registry {
    server               = local.image_server
    username             = var.acr_credentials.username
    password_secret_name = "acr-password"
  }

  template {
    container {
      name   = "web"
      image  = var.image
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "NODE_ENV"
        value = "production"
      }
    }
  }

  ingress {
    external_enabled = var.external_ingress
    target_port      = var.target_port
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    environment = var.env_name
  }
}
