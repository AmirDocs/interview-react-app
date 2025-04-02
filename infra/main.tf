# module "rg" {
#   source = "./modules/rg"

#   name     = "${var.app_name}-${var.env_name}-rg"
#   location = var.location
# }

module "network" {
  source             = "./modules/networking"
  rg_name            = var.resource_group_name
  location           = var.location
  vnet_address_space = var.vnet_address_space
  subnet_prefix      = var.subnet_address_prefix
}

module "acr" {
  source   = "./modules/acr"
  name     = "${var.app_name}${var.env_name}acr"
  rg_name  = var.resource_group_name
  location = var.location
}

module "env" {
  source    = "./modules/container-env"
  name      = "${var.app_name}-${var.env_name}-env"
  rg_name   = var.resource_group_name
  location  = var.location
  subnet_id = module.network.subnet_id
}

module "app" {
  source           = "./modules/container-app"
  name             = "${var.app_name}-${var.env_name}"
  rg_name          = var.resource_group_name
  container_env_id = module.env.id
  location         = var.location
  image            = "${module.acr.login_server}/${var.app_name}:${var.image_tag}"
  acr_credentials  = module.acr.credentials
  # ingress settings
  external_ingress = true
  target_port      = 80
}

module "dns" {
  source      = "./modules/dns"
  rg_name     = var.resource_group_name
  zone_name   = "amirbeile.uk"
  record_name = "investorflow"
  app_fqdn    = module.app.fqdn
}

# locals {
#   env_config_path = "${path.root}/../environments/${var.env}/${var.env}.tfvars"
# }
