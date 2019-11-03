variable "region" {
  default = "us-east-1"
}

variable "environment" {
  default = "prod"
}


variable "repository_name" {
  default = "project-2019"
}

variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-b374d5a5"
  }
}