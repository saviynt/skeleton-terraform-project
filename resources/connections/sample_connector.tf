resource "saviynt_resource_ad_connection" "sample" {
  connection_type         = "AD"
  connection_name         = "YOUR_CONNECTION_NAME"
  url                     = format("%s://%s:%d", "LSAP_PROTOCOL", "IP_ADDRESS", "LDAP_PORT")
  password                = "PASSWORD"
  username                = "BIND_USER"
  ldap_or_ad              = "AD"
  base                    = "BASE_CONTAINER"
}