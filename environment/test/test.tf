terraform {
  required_providers {
    saviynt = {
      source  = "PROVIDER PATH"
      version = "1.0.0"
    }
  }
}

provider "saviynt" {
  server_url      = var.SAVIYNT_SERVER_URL
  server_username = var.SAVIYNT_USERNAME
  server_password = var.SAVIYNT_PASSWORD
}

resource "saviynt_ad_connection_resource" "sample" {
  connection_type         = "AD"
  connection_name         = "YOUR_CONNECTION_NAME"
  url                     = format("%s://%s:%d",var.LDAP_PROTOCOL, var.IP_ADDRESS, var.LDAP_PORT)
  password                = var.PASSWORD
  username                = var.USERNAME
  ldap_or_ad              = "AD"
  base                    = var.BASE_CONTAINER
}
