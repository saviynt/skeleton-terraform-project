terraform {
  required_providers {
    saviynt = {
      source  = "registry.terraform.io/local/saviynt"
      version = "1.0.0"
    }
  }
}

provider "saviynt" {
  server_url = "YOUR_SERVER_URL"
  username   = "YOUR_USERNAME"
  password   = "YOUR_PASSWORD"
}