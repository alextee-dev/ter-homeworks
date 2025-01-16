terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name                = var.name
  environment         = "PRESTABLE"
  network_id          = var.network_id
  version             = "8.0"
#  security_group_ids  = [ "<список_идентификаторов_групп_безопасности>" ]
  deletion_protection = false

  resources {
    resource_preset_id = "c3-c2-m4"
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = var.subnet_id
    assign_public_ip = true
#    priority         = <приоритет_при_выборе_хоста-мастера>
#    backup_priority  = <приоритет_для_резервного_копирования>
  }

    host {
    zone             = "ru-central1-a"
    subnet_id        = var.subnet_id
    assign_public_ip = true
#    priority         = <приоритет_при_выборе_хоста-мастера>
#    backup_priority  = <приоритет_для_резервного_копирования>
  }
}