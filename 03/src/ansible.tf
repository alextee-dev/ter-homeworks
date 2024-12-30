resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",

  { webservers = yandex_compute_instance.platform, databases = yandex_compute_instance.platform2, storage = yandex_compute_instance.platform3 })

  filename = "${abspath(path.module)}/hosts.ini"
}

resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [yandex_compute_instance.platform, yandex_compute_instance.platform2, yandex_compute_instance.platform3]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command    = "> ~/.ssh/known_hosts &&eval $(ssh-agent) && cat ~/.ssh/ycservice | ssh-add -"
    on_failure = continue #Продолжить выполнение terraform pipeline в случае ошибок
  }

  #Костыль!!! Даем ВМ 60 сек на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
  # # В случае использования cloud-init может потребоваться еще больше времени
  # provisioner "local-exec" {
  #   command = "sleep 60"
  # }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    # without secrets
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/hosts.ini ${abspath(path.module)}/test.yml"
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    always_run      = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются
    always_run_uuid = "${uuid()}"
    # playbook_src_hash = file("${abspath(path.module)}/test.yml") # при изменении содержимого playbook файла
    # ssh_public_key = var.public_key # при изменении переменной with ssh
    # template_rendered = "${local_file.hosts_templatefile.content}" #при изменении inventory-template
    # password_change = jsonencode( {for k,v in random_password.each: k=>v.result})

  }

}