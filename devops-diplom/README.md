# Дипломный практикум в YandexCloud - Григорьев Александр
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
      * [Регистрация доменного имени](#регистрация-доменного-имени)
      * [Создание инфраструктуры](#создание-инфраструктуры)
          * [Установка Nginx и LetsEncrypt](#установка-nginx)
          * [Установка кластера MySQL](#установка-mysql)
          * [Установка WordPress](#установка-wordpress)
          * [Установка Gitlab CE, Gitlab Runner и настройка CI/CD](#установка-gitlab)
          * [Установка Prometheus, Alert Manager, Node Exporter и Grafana](#установка-prometheus)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

---
## Цели:

1. Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).
2. Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud.
3. Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
4. Настроить кластер MySQL.
5. Установить WordPress.
6. Развернуть Gitlab CE и Gitlab Runner.
7. Настроить CI/CD для автоматического развёртывания приложения.
8. Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.

---
## Этапы выполнения:

### Регистрация доменного имени
___
```commandline
- Зарегистрировано доменное имя 'alexgrigu.ru' у регистратора nic.ru
- Настроен хостинг DNS в YandexCloud ns1.yandexcloud.net и ns2.yandexcloud.net
```
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/nicru.JPG)
Создан S3 bucket в YC
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/Bucket.JPG)
### Создание инфраструктуры

Структура файлов:
- `main.tf`      Настройки провайдера и данные для подключения к Yandex Cluod.
- `network.tf`   Настройки сетей и добавление A-записей.
- `output.tf`    Значения вывода.
- `variables.tf` Переменные.
- `vms.tf`       Описание виртуальных машин и привязки их к необходимым сетям.
- `meta.txt`     Переменная с открытым ключом пользователя для подключения в хостам - добавлена в .gitignore
- `key.json`     Ключ для подключения к YC.

Хост с NAT развернут на базе NAT-инстанса - https://cloud.yandex.ru/docs/tutorials/routing/nat-instance
Остальные хосты на базе образа ubuntu 20.04 LTS

Развернута инфраструктура с помощью terraform в директории с файлами *.tf:
```terraform
terraform workspace new stage
terraform workspace select stage 
terraform init -backend-config=backend.conf
terraform plan
terraform apply -auto-approve
```
После применения terraform apply забираем из output данные для ssh-подключения к хостам и записываем в `~/.ssh/config`
Также добавляем IP-адреса серверов в `variables.yml`
И добавляем IP-адреса в конфигурацию [Prometheus](https://github.com/AlexGrigu/devops-netology/blob/main/devops-diplom/ansible/roles/monitoring/stack/prometheus/prometheus.yml)
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/Main_yc.JPG)
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/DNS.JPG)
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/Compute_cloud.JPG)

# Развертывание ролей
___
Все роли находятся в директории /ansible/roles

Также в корне ansible присутствуют:
ansible.cfg - указан путь к inventory-файлу и добавлена переменная для запуска ролей
inventory - описание хостов
### Установка Nginx и LetsEncrypt
```yaml
ansible-playbook -i inventory roles/main/tasks/main.yml
```
___
### Установка кластера MySQL
```yaml
ansible-playbook -i inventory roles/db/tasks/main.yml
```
___
### Установка WordPress
```yaml
ansible-playbook -i inventory roles/app/tasks/main.yml
```
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/Wordpress.JPG)
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/Wordpress_cert.JPG)

---
### Установка Gitlab CE и Gitlab Runner
Установка двух хостов производилась из одной роли
За основу был взят образ gitlab:
- gitlab - https://github.com/sameersbn/docker-gitlab
- gitlab-runner - устанавливался из оригинального скрипта https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh
```yaml
ansible-playbook -i inventory roles/gitlab/tasks/main.yml
Создан проект - Wordpress. Для него был зарегистрирован runner
gitlab-runner register
...
```
![]()
![]()
![]()
___
### Установка Prometheus, Alert Manager, Node Exporter и Grafana
```yaml
ansible-playbook -i inventory roles/monitoring/tasks/main.yml
```
Alertmanager
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/Alertmanager.JPG)
Grafana
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/Grafana.JPG)
Prometheus
![](https://raw.githubusercontent.com/AlexGrigu/devops-netology/main/devops-diplom/img/Prometheus.JPG)
