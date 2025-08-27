terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

locals {
    environment = "prod" # dev, staging, prod
    upper_case = upper(local.environment)
    base_path = "${path.module}/configs/${local.upper_case}"
}

resource "local_file" "service_configs" {
    filename = "${local.base_path}/service.sh"
    content = <<EOT
    environment = ${local.environment}
    port=3000
    EOT
}

resource "local_file" "service_configs_2" {
    filename = "${local.base_path}/service2.sh"
    content = <<EOT
    environment = ${local.environment}
    port=3000
    EOT
}

resource "local_file" "service_configs_3" {
    filename = "${local.base_path}/service3.sh"
    content = <<EOT
    environment = ${local.environment}
    port=3000
    EOT
}

# Outputs
output "filename" {
    value = local_file.service_configs.filename
    sensitive = true
}