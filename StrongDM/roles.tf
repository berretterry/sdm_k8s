# Create StrongDM Role

resource "sdm_role" "bt_role" {
  name = "bt-role"
  tags = {
      owner = "Berret"
    }

  access_rules = jsonencode([
    {"tags": {
      "owner": "Berret"
      }
    }
  ])
}

resource "sdm_account_attachment" "bt_role" {
  account_id = "a-7e96b21066be4e2d"
  role_id = sdm_role.bt_role.id
}