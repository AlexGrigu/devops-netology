terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version =  ">= 0.13"
}

provider yandex {
  service_account_key_file = "key.json"
  cloud_id		   = var.yandex_cloud_id
  folder_id 	   = var.yandex_folder_id
  zone			   = "ru-central1-a"
}

terraform {
    backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket = "alexgrigu.web"
    region = "ru-central1-a"
    key = "stage/terraform.tfstate"
    access_key = "YCAJEsZKwr5nTxVpN0rAZYtwS"
    secret_key = "YCMSQ42uozWVtERW2ZiKQwoS8AJyhgiCTiMYcdu8"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

#  metadata = {
#    user-data = "${file("meta.txt")}"
#  }
#}
#  metadata = {
#    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
#  }
#}
#resource yandex_compute_image ubu-img {
#  name         = "ubuntu-20-04-lts-v20220620"
#  source_image = "fd8f1tik9a7ap9ik2dg1"
#}
