resource "azurerm_dns_cname_record" "app" {
  name                = var.record_name
  zone_name           = var.zone_name
  resource_group_name = var.rg_name
  ttl                 = 300
  record              = var.app_fqdn
}