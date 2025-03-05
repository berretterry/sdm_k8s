#StrongDM SSH public Keys

output "sdm_web_server_public_key" {
  description = "StrongDM web-server public key"
  value = sdm_resource.bt_web_server.ssh[0].public_key
}

output "sdm_app_server_public_key" {
  description = "StrongDM app-server public key"
  value = sdm_resource.bt_app_server.ssh[0].public_key
}

output "gateway_token" {
  description = "StrongDM Gateway Token"
  value = sdm_node.bt_gateway.gateway[0].token
  sensitive = true
}

output "app_relay_token" {
  description = "StrongDM app server relay token"
  value = sdm_node.app_relay.relay[0].token
  sensitive = true
}

output "db_relay_token" {
  description = "StrongDM database relay token"
  value = sdm_node.db_relay.relay[0].token
  sensitive = true
}