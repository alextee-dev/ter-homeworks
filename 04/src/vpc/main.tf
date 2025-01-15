terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

#создаем облачную сеть
resource "yandex_vpc_network" "prod" {
  name = var.name
}

#создаем подсеть
resource "yandex_vpc_subnet" "prod_a" {
  name           = var.name
  zone           = var.zone
  network_id     = yandex_vpc_network.prod.id
  v4_cidr_blocks = var.v4_cidr_blocks
}