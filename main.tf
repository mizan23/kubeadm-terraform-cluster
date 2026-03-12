module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id
}

module "compute" {
  source = "./modules/compute"

  vpc_id          = module.network.vpc_id
  public_subnet   = module.network.public_subnet_id
  private_subnet  = module.network.private_subnet_id
  security_group  = module.security.security_group_id

  depends_on = [
    module.network.nat_gateway_id,
    module.security
  ]

  key_name        = var.key_name
  instance_type   = var.instance_type
  worker_count    = var.worker_count
}