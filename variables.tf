variable "region" {
  default = "us-east-1"
}

variable "environment" {
  default = "production"
}

variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-b374d5a5"
  }
}

variable "public_subnets_cidr" {
  type = "list"
  default = [
    "10.0.6.0/24",
    "10.0.7.0/24"
  ]
}

variable "private_subnets_cidr" {
  type = "list"
  default = [
    "10.0.24.0/24"
  ]
}

variable "availability_zones" {
  type = "list"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1e"
  ]
}

variable "database" {
  type = "map"
  default = {
    instance = "db.t2.micro"
    name = "hpaiva2019"
    username = "hpaiva"
    password = "hpaiva#2019"
  }
}
