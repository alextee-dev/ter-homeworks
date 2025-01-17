# Модуль создания сети prod
module "vpc_prod" {
  source       = "./vpc"
  env_name     = var.prod_name
  name = var.prod_name
  subnets = var.vpc_prod
}

# Модуль создания сети dev
module "vpc_dev" {
  source       = "./vpc"
  env_name     = var.dev_name
  name = var.dev_name
  subnets = var.vpc_dev
}

# Модуль создания кластера MySQL
module "mysql" {
  source = "./mysql"
  name = var.cluster_name
  network_id = module.vpc_prod.yandex_vpc_network.id
  subnet_id = module.vpc_prod.yandex_vpc_subnet.ru-central1-a.id
  
}

# Модуль создания БД и пользователя
module "mysql_db" {
  source = "./mysql_db"
  cluster_id = module.mysql.yandex_mdb_mysql_cluster.id
  db_name = var.db_name
  db_user = var.db_user
}

# module "marketing-vm" {
#   source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
#   env_name       = var.prod_name
#   network_id     = module.vpc_prod.yandex_vpc_network.id
#   subnet_zones   = [var.zone1]
#   subnet_ids     = [module.vpc_prod.yandex_vpc_subnet.id]
#   instance_name  = var.vm_marketing_name
#   instance_count = 2
#   image_family   = var.vm_os_family
#   public_ip      = true

#   labels = {
#     project = "marketing"
#      }

#   metadata = {
#     user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
#     serial-port-enable = 1
#   }

# }

# module "analytics-vm" {
#   source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
#   env_name       = "stage"
#   network_id     = module.vpc_prod.yandex_vpc_network.id
#   subnet_zones   = [var.zone1]
#   subnet_ids     = [module.develop.yandex_vpc_subnet.id]
#   instance_name  = var.vm_analytics_name
#   instance_count = 1
#   image_family   = var.vm_os_family
#   public_ip      = true

#   labels = {
#     project = "analytics"
#      }

#   metadata = {
#     user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
#     serial-port-enable = 1
#   }

# }

data template_file "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file(var.vms_ssh_root_key)
  }
}

