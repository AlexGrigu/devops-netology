variable "yandex_cloud_id" {
  default = "b1ggsj6s8f9eofnpf5ne"
}

variable "yandex_folder_id" {
  default = "b1gfb6f09o8jua05edio"
}

variable "subnets" {
  type = list(string)
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "zones" {
  type = list(string)  
  default = ["ru-central1-a", "ru-central1-b"]
}

variable "ubuntu" {
  default = "fd87tirk5i8vitv9uuo1"
}

variable "vm" {
  type = list(string)
  default = ["alexgrigu.ru", "db01.alexgrigu.ru", "db02.alexgrigu.ru", "app.alexgrigu.ru", "gitlab.alexgrigu.ru", "runner.alexgrigu.ru", "monitoring.alexgrigu.ru"]
}

#variable "SSH_ID_RSA_PUB" {}
