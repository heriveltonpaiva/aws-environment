terraform {
  backend "s3" {
    bucket = "terraform-state-hpaiva"
    key="myapp/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
