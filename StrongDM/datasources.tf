### Creating StrongDM Datasources

resource "sdm_resource" "bt_database" {
  maria {
    name = "bt_database"
    hostname = data.terraform_remote_state.infra.outputs.db_instance_address
    username = data.terraform_remote_state.infra.outputs.mysql_username
    password = data.terraform_remote_state.infra.outputs.mysql_pass
    database = "sdm_database"
    port = 3306
    tags = {
      owner = "Berret"
    }
  }


}