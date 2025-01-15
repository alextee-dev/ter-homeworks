#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop_a" {
  name           = "${var.vpc_name}-a"
  zone           = var.zone1
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr1
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = var.zone2
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr2
}

module "vpc" {
  source = "./vpc"
  name = "develop-c"
  zone = var.zone1
  v4_cidr_blocks = ["10.0.3.0/24"]
}

module "marketing-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop" 
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.zone1,var.zone2]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id,yandex_vpc_subnet.develop_b.id]
  instance_name  = var.vm_marketing_name
  instance_count = 2
  image_family   = var.vm_os_family
  public_ip      = true

  labels = { 
    project = "marketing"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

module "analytics-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.zone1]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id]
  instance_name  = var.vm_analytics_name
  instance_count = 1
  image_family   = var.vm_os_family
  public_ip      = true

  labels = { 
    project = "analytics"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
data template_file "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file(var.vms_ssh_root_key)
  }
}