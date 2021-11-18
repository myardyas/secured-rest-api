resource "azurerm_resource_group" "demo" {
  name     = var.name
  location = var.resource_group_location
}

# See available inputs at https://registry.terraform.io/modules/Azure/network/azurerm/latest?tab=inputs
module "network" {
  source              = "Azure/network/azurerm"
  version             = "3.5.0"
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  depends_on          = [azurerm_resource_group.demo]
}

# See available inputs at https://registry.terraform.io/modules/Azure/aks/azurerm/latest?tab=inputs
module "aks" {
  source                         = "Azure/aks/azurerm"
  version                        = "4.13.0"
  resource_group_name            = azurerm_resource_group.demo.name
  cluster_name                   = var.name
  kubernetes_version             = var.cluster_version
  orchestrator_version           = var.cluster_version
  prefix                         = var.name
  network_plugin                 = "azure"
  network_policy                 = "azure"
  vnet_subnet_id                 = module.network.vnet_subnets[0]
  private_cluster_enabled        = "false"
  agents_size                    = var.node_size
  agents_min_count               = var.pool_size
  agents_max_count               = var.pool_size
  agents_count                   = var.pool_size
  agents_pool_name               = var.pool_name
  agents_tags                    = var.tags
  net_profile_dns_service_ip     = var.net_profile_dns_service_ip
  net_profile_docker_bridge_cidr = var.net_profile_docker_bridge_cidr
  net_profile_service_cidr       = var.net_profile_service_cidr
  depends_on                     = [module.network]
}

resource "azurerm_container_registry" "demo" {
  name                = format("%s%s", var.name, "iris")
  resource_group_name = azurerm_resource_group.demo.name
  location            = var.resource_group_location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_public_ip" "demo" {
  name                = var.name
  resource_group_name = azurerm_resource_group.demo.name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_role_assignment" "acr" {
  principal_id         = module.aks.kubelet_identity[0].object_id
  scope                = azurerm_container_registry.demo.id
  role_definition_name = "AcrPull"
}
