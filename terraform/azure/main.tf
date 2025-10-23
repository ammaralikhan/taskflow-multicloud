# Configure Azure Provider
provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "taskflow" {
  name     = "rg-taskflow-docker"
  location = "West Europe"
}

# Create App Service Plan
resource "azurerm_app_service_plan" "taskflow" {
  name                = "asp-taskflow"
  location            = azurerm_resource_group.taskflow.location
  resource_group_name = azurerm_resource_group.taskflow.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

# Create Web App (Container)
resource "azurerm_app_service" "taskflow_docker" {
  name                = "taskflow-docker"
  location            = azurerm_resource_group.taskflow.location
  resource_group_name = azurerm_resource_group.taskflow.name
  app_service_plan_id = azurerm_app_service_plan.taskflow.id

  site_config {
    linux_fx_version = "DOCKER|ammaralikhan00/taskflow-api:52"
    always_on        = true
    app_command_line = ""
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL = "https://index.docker.io/v1/"
    DOCKER_REGISTRY_SERVER_USERNAME = "ammaralikhan00"
    DOCKER_REGISTRY_SERVER_PASSWORD = var.docker_hub_password
  }
}

# Output URL
output "app_url" {
  value = azurerm_app_service.taskflow_docker.default_site_hostname
}
