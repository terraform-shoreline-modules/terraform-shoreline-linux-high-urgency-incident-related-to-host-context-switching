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

module "high_urgency_incident_related_to_host_context_switching" {
  source    = "./modules/high_urgency_incident_related_to_host_context_switching"

  providers = {
    shoreline = shoreline
  }
}