resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "private_vpc_subnet" {
  name           = "private-vpc-subnet"
  network_id     = yandex_vpc_network.network.id
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.10.1.0/24"]
  route_table_id = yandex_vpc_route_table.nat_vpc_route_table.id

  depends_on = [
    yandex_vpc_route_table.nat_vpc_route_table
  ]
}

resource "yandex_vpc_subnet" "public_vpc_subnet" {
  name           = "public-vpc-subnet"
  network_id     = yandex_vpc_network.network.id
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.10.2.0/24"]
}

resource "yandex_dns_zone" "dns_zone" {
  name             = "public-dns-zone"
  zone             = "alexgrigu.ru."
  public           = true
  private_networks = [yandex_vpc_network.network.id]
}

resource "yandex_dns_recordset" "www" {
  zone_id = yandex_dns_zone.dns_zone.id
  name    = "www.alexgrigu.ru."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.main_instance.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "gitlab" {
  zone_id = yandex_dns_zone.dns_zone.id
  name    = "gitlab.alexgrigu.ru."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.main_instance.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "grafana" {
  zone_id = yandex_dns_zone.dns_zone.id
  name    = "grafana.alexgrigu.ru."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.main_instance.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "prometheus" {
  zone_id = yandex_dns_zone.dns_zone.id
  name    = "prometheus.alexgrigu.ru."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.main_instance.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "alertmanager" {
  zone_id = yandex_dns_zone.dns_zone.id
  name    = "alertmanager.alexgrigu.ru."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.main_instance.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "main" {
  zone_id = yandex_dns_zone.dns_zone.id
  name    = "main.alexgrigu.ru."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.main_instance.network_interface.0.nat_ip_address]
}

resource "yandex_vpc_route_table" "nat_vpc_route_table" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.proxy_instance.network_interface.0.ip_address
  }

  depends_on = [
    yandex_compute_instance.proxy_instance
  ]
}
