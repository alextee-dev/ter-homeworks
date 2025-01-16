# module "develop" {
#   source = "./vpc"
#   name = "${var.vpc_name}"
#   zone = var.zone1
#   v4_cidr_blocks = var.cidr1
# }

module "vpc_prod" {
  source       = "./vpc"
  env_name     = var.prod_name
  name = var.prod_name
  subnets = var.vpc_prod
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = var.dev_name
  name = var.dev_name
  subnets = var.vpc_dev
}

module "mysql" {
  source = "./mysql"
  name = "mysql_cl1"
  network_id = module.vpc_prod.yandex_vpc_network.id
  subnet_id = module.vpc_prod.yandex_vpc_subnet.ru-central1-a.id
  
}

# resource "yandex_mdb_mysql_database" "<имя_БД>" {
#   cluster_id = "<идентификатор_кластера>"
#   name       = "<имя_БД>"
# }

# resource "yandex_mdb_mysql_user" "<имя_пользователя>" {
#   cluster_id = "<идентификатор_кластера>"
#   name       = "<имя_пользователя>"
#   password   = "<пароль_пользователя>"
#   permission {
#     database_name = "<имя_БД>"
#     roles         = ["ALL"]
#   }
# }

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

