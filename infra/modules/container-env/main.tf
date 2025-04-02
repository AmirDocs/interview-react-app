resource "azurerm_container_app_environment" "this" {
  name                = "container-app-env"
  location            = var.location
  resource_group_name = var.rg_name

  infrastructure_subnet_id = var.subnet_id
  zone_redundancy_enabled  = false

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 1
  }
}
