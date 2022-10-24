resource "yandex_compute_instance" "proxy_instance" {
  name     = "proxy"
  hostname = "proxy.alexgrigu.ru"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd84mnpg35f7s7b0f5lg"
      size     =5
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_vpc_subnet.id
    nat       = true
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_compute_instance" "main_instance" {
  name = "main"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
    nat       = true
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_compute_instance" "db01_instance" {
  name = "db01"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_compute_instance" "db02_instance" {
  name = "db02"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_compute_instance" "app_instance" {
  name = "app"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_compute_instance" "monitoring_instance" {
  name = "monitoring"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_compute_instance" "gitlab_instance" {
  name = "gitlab"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_compute_instance" "runner_instance" {
  name = "runner"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}
