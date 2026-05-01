resource "azurerm_resource_group" "onix_rg" {
  name     = "Onix-RG"
  location = "Canada Central"
}

# Container App Environment
resource "azurerm_container_app_environment" "onix_env" {
  name                = "onix-environment"
  location            = azurerm_resource_group.onix_rg.location
  resource_group_name = azurerm_resource_group.onix_rg.name
}

resource "azurerm_container_app" "onix_app" {
  name                         = "onix-website-app"
  container_app_environment_id = azurerm_container_app_environment.onix_env.id
  resource_group_name          = azurerm_resource_group.onix_rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "onix-website"
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

variable "container_image" {
  type        = string
  description = "The docker image to deploy"
}
