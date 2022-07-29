terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version =  ">= 0.13"
}

provider yandex {
  token     = "secrettoken"
  cloud_id  = "b1ggsj6s8f9eofnpf5ne"
  folder_id = "b1gfb6f09o8jua05edio"
  zone      = "ru-central1-a"
}

resource yandex_compute_image ubu-img {
  name          = "ubuntu-20-04-lts-v20220620"
  source_image  = "fd8f1tik9a7ap9ik2dg1"
}
