output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "master_public_ip" {
  value = module.compute.master_public_ip
}