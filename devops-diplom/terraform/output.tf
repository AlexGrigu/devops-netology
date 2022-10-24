output "main_alexgrigu_ru_ip_addr_external" {
  value = yandex_compute_instance.main_instance.network_interface.0.nat_ip_address
}

output "db01_alexgrigu_ru_ip_addr_internal" {
  value = yandex_compute_instance.db01_instance.network_interface.0.ip_address
}

output "db02_alexgrigu_ru_ip_addr_internal" {
  value = yandex_compute_instance.db02_instance.network_interface.0.ip_address
}

output "app_alexgrigu_ru_ip_addr_internal" {
  value = yandex_compute_instance.app_instance.network_interface.0.ip_address
}

output "monitoring_alexgrigu_ru_ip_addr_internal" {
  value = yandex_compute_instance.monitoring_instance.network_interface.0.ip_address
}

output "gitlab_alexgrigu_ru_ip_addr_internal" {
  value = yandex_compute_instance.gitlab_instance.network_interface.0.ip_address
}

output "runner_alexgrigu_ru_ip_addr_internal" {
  value = yandex_compute_instance.runner_instance.network_interface.0.ip_address
}

output "ssh_config" {
  value = <<-EOT
  Host alexgrigu.ru
    HostName ${yandex_compute_instance.main_instance.network_interface.0.nat_ip_address}
    User alexxas
    IdentityFile ~/.ssh/id_rsa

  Host db01.alexgrigu.ru
    HostName ${yandex_compute_instance.db01_instance.network_interface.0.ip_address}
    User alexxas
    IdentityFile ~/.ssh/id_rsa
      ProxyJump alexxas@${yandex_compute_instance.proxy_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host db02.alexgrigu.ru
    HostName ${yandex_compute_instance.db02_instance.network_interface.0.ip_address}
    User alexxas
    IdentityFile ~/.ssh/id_rsa
      ProxyJump alexxas@${yandex_compute_instance.proxy_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host app.alexgrigu.ru
    HostName ${yandex_compute_instance.app_instance.network_interface.0.ip_address}
    User alexxas
    IdentityFile ~/.ssh/id_rsa
      ProxyJump alexxas@${yandex_compute_instance.proxy_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host monitoring.alexgrigu.ru
    HostName ${yandex_compute_instance.monitoring_instance.network_interface.0.ip_address}
    User alexxas
    IdentityFile ~/.ssh/id_rsa
      ProxyJump alexxas@${yandex_compute_instance.proxy_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host gitlab.alexgrigu.ru
    HostName ${yandex_compute_instance.gitlab_instance.network_interface.0.ip_address}
    User alexxas
    IdentityFile ~/.ssh/id_rsa
      ProxyJump alexxas@${yandex_compute_instance.proxy_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host runner.alexgrigu.ru
    HostName ${yandex_compute_instance.runner_instance.network_interface.0.ip_address}
    User alexxas
    IdentityFile ~/.ssh/id_rsa
      ProxyJump alexxas@${yandex_compute_instance.proxy_instance.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  EOT
}
