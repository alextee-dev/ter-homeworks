resource "yandex_vpc_network" "develop-a" {
  name = var.vpc_name1
}
resource "yandex_vpc_subnet" "develop-a" {
  name           = var.vpc_name1
  zone           = var.default_zone-a
  network_id     = yandex_vpc_network.develop-a.id
  v4_cidr_blocks = var.default_cidr-a
}

resource "yandex_vpc_network" "develop-b" {
  name = var.vpc_name2
}
resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vpc_name2
  zone           = var.default_zone-b
  network_id     = yandex_vpc_network.develop-b.id
  v4_cidr_blocks = var.default_cidr-b
}


data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  name        = "${var.vm_web_name}"
  platform_id = "${var.vm_web_platform}"
  resources {
    cores         = "${var.vm_web_resources.cores}"
    memory        = "${var.vm_web_resources.memory}"
    core_fraction = "${var.vm_web_resources.core_fraction}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-a.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

resource "yandex_compute_instance" "platform2" {
  name        = "${var.vm_db_name}"
  platform_id = "${var.vm_db_platform}"
  zone        = "${var.vm_db_zone}"
  resources {
    cores         = "${var.vm_db_resources.cores}"
    memory        = "${var.vm_db_resources.memory}"
    core_fraction = "${var.vm_db_resources.core_fraction}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}