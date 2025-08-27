terraform {
  backend "local" {
    path = "/Users/aravpatel/terraform/state-file/terraform.tfstate"
  }
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.3"
    }
  }
}