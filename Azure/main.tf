terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.31.0"
    }
  }

  # backend "azurerm" {

  # }
}

provider "azurerm" {
  features {

  }
}

module "rg" {
  source   = "./modules/ResourceGroup"
  name     = var.prefix
  location = var.location
  tags     = var.tags
}

module "acr" {
  source            = "./modules/acr"
  resourceGroupName = module.rg.name
  name              = var.prefix
  location          = var.location
  tags              = var.tags
}

module "aks" {
  source            = "./modules/AKS"
  resourceGroupName = module.rg.name
  prefix            = var.prefix
  location          = var.location
  deploymenttype    = var.environment
  tags              = var.tags
}

module "VNet" {
  source        = "./modules/VNet"
  name_rg       = module.rg.name
  location      = var.location
  netname       = var.prefix
  address_space = var.address_space
  tags          = var.tags
}
