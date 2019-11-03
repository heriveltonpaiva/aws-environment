module "ecr" {
  source = "./ecr"
}

module "ecs" {
  source = "./ecs"
}

module "network" {
  source = "./network"
}

module "iam" {
  source = "./iam"
}