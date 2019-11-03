module "ecr" {
  source = "./ecr"

  environment = var.environment
}

module "ecs" {
  source = "./ecs"

  environment = var.environment
  public_subnet = module.network.public_subnet
  private_subnet = module.network.private_subnet
  target_group = module.alb.target_group
  security_group = module.security_group
  ecr = module.ecr
}

module "network" {
  source = "./network"

  environment = var.environment
}

module "security_group" {
  source = "./security-group"

  environment = var.environment
  vpc_id = module.network.vpc_id
}

module "alb" {
  source = "./alb"

  environment = var.environment
  vpc_id = module.network.vpc_id
  public_subnet = module.network.public_subnet
  security_group = module.security_group
}

module "iam" {
  source = "./iam"
}