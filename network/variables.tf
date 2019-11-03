variable "environment" {
  default = "prod"
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