
module "networks" {
  source         = "./modules/networks"
}

module "ctfd_vm" {
  source       = "./modules/virtual_machines/ctfd/"
}

module "redis_vm" {
  source       = "./modules/virtual_machines/redis/"
}

module "nginx_vm" {
  source       = "./modules/virtual_machines/nginx/"
}

module "mariadb_vm" {
  source       = "./modules/virtual_machines/mariadb/"
}