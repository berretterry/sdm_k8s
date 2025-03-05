### Creating StrongDM servers

resource "sdm_resource" "bt_app_server" {
  ssh {
    name = "bt_app_server"
    hostname = data.terraform_remote_state.infra.outputs.app_private_ip
    username = "ubuntu"
    port = 22
    tags = {
      owner = "Berret"
    }

  }

}

resource "sdm_resource" "bt_web_server" {
  ssh {
    name = "bt_web_server"
    hostname = data.terraform_remote_state.infra.outputs.web_private_ip
    username = "ubuntu"
    port = 22
    tags = {
      owner = "Berret"
    }

  }

}