terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "etcd_member_communication_slow_incident" {
  source    = "./modules/etcd_member_communication_slow_incident"

  providers = {
    shoreline = shoreline
  }
}