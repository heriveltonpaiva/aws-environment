data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = "terraform-state-hpaiva"
    key = "myapp/dev/terraform.tfstate"
    region = "us-east-1"
  }
}