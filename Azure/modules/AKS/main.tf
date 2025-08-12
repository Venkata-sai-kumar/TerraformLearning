provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = var.resourceGroupName
  address_space       = ["10.220.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-k8s-nodes"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = var.resourceGroupName
  address_prefixes     = ["10.220.0.0/20"]
}

resource "azurerm_kubernetes_cluster" "example" {
  name                         = "${var.prefix}-K8s"
  location                     = var.location
  resource_group_name          = var.resourceGroupName
  dns_prefix                   = "${var.prefix}-K8s-dns"
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 240
  kubernetes_version           = "1.32"
  oidc_issuer_enabled          = true
  workload_identity_enabled    = true
  automatic_upgrade_channel    = "stable"

  default_node_pool {
    name                 = "systemnodes"
    node_count           = 1
    vm_size              = "Standard_DS2_v2"
    vnet_subnet_id       = azurerm_subnet.internal.id
    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 2
    max_pods             = 50

    upgrade_settings {
      max_surge                = "33%"
      drain_timeout_in_minutes = 10
    }
    # 👇 Required when changing certain node pool properties
    temporary_name_for_rotation = "nodepool01"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "example" {
  count                 = lower(var.deploymenttype) == "production" ? 1 : 0
  name                  = "spotnodes"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  vnet_subnet_id        = azurerm_subnet.internal.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  mode                  = "User"
  priority              = "Spot"
  os_type               = "Linux"
  spot_max_price        = 0.05 # note: this is the "maximum" price
  auto_scaling_enabled  = true
  min_count             = 0
  max_count             = 2
  max_pods              = 50
  eviction_policy       = "Delete"
  orchestrator_version  = azurerm_kubernetes_cluster.example.kubernetes_version
  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }
  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]
  tags = var.tags

  # 👇 Required when changing certain node pool properties
  temporary_name_for_rotation = "rotate01"
}
