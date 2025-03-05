data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "strongdm-challenge-backend-1"
    key = "strongdm-challenge/terraform.tfstate"
    region = "us-west-2"
  }
}
