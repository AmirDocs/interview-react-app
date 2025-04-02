output "login_server" {
  value = azurerm_container_registry.this.login_server
}

output "credentials" {
  value = {
    username = azurerm_container_registry.this.admin_username
    password = azurerm_container_registry.this.admin_password
  }
}
