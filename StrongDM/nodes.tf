### Creating StrongDM Gateway

resource "sdm_node" "bt_gateway" {
    gateway {
        name = "bt-gateway"
        listen_address = "${data.terraform_remote_state.infra.outputs.sdmgw_public_ip}:5000"
        bind_address = "0.0.0.0:5000"
        tags = {
            region = "us-west-2"
            owner = "Berret"
        }
    }
}

resource "sdm_node" "app_relay" {
  relay {
    name = "bt-app-relay"
  }
}

resource "sdm_node" "db_relay" {
  relay {
    name = "bt-db-relay"
  }
}