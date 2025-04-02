resource "azurerm_virtual_network" "main" {
  name                = "${var.rg_name}-vnet"
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = [var.vnet_address_space]
}

resource "azurerm_subnet" "main" {
  name                 = "aca-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_prefix]

  delegation {
    name = "aca-delegation"

    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}



resource "azurerm_public_ip" "nat_gw" {
  name                = "${var.rg_name}-natgw-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

## Lab envmt won't me create below resources. Due to limitation of the lab envmt.

# resource "azurerm_nat_gateway" "main" {
#   name                = "${var.rg_name}-natgw"
#   location            = var.location
#   resource_group_name = var.rg_name
#   sku_name            = "Standard"
# }

# resource "azurerm_nat_gateway_public_ip_association" "assoc" {
#   nat_gateway_id       = azurerm_nat_gateway.main.id
#   public_ip_address_id = azurerm_public_ip.nat_gw.id
# }

# resource "azurerm_subnet_nat_gateway_association" "main" {
#   subnet_id      = azurerm_subnet.main.id
#   nat_gateway_id = azurerm_nat_gateway.main.id
# }

