output "count" {

  value = [
    { name = yandex_compute_instance.platform.*.name
      id = yandex_compute_instance.platform.*.id
      fqdn = yandex_compute_instance.platform.*.fqdn}
  ]
}

output "for_each" {

  value = [
   { name = values(yandex_compute_instance.platform2).*.name
      id = values(yandex_compute_instance.platform2).*.id
      fqdn = values(yandex_compute_instance.platform2).*.fqdn}
  ]
}

output "single_vm" {

  value = [
    { name = yandex_compute_instance.platform3.name
      id = yandex_compute_instance.platform3.id
      fqdn = yandex_compute_instance.platform3.fqdn}
  ]
}
