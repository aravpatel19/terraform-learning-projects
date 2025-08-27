terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

resource "local_file" "example1" {
  content  = "This is demo content!"
  filename = "${path.module}/${var.filename}.txt"
}