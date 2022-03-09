# Курсовая работа по итогам модуля "DevOps и системное администрирование"

## Задание

- Создание виртуальной машины Linux.
- Установка ufw, разрешение портов 22 и 443

```bash
vagrant@vagrant:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
443                        ALLOW       Anywhere
Anywhere                   ALLOW       127.0.0.1
22                         ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
443 (v6)                   ALLOW       Anywhere (v6)
22 (v6)                    ALLOW       Anywhere (v6)
```

- Установка hashicorp vault

```bash
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt-get update && sudo apt-get install vault
$ vault server -dev -dev-root-token-id=root

# Создаем новую сессию, дальнейшие действия делаем в ней
$ export VAULT_ADDR=http://127.0.0.1:8200
$ export VAULT_TOKEN=root
```

- Создание центра сертификации и генерация корневого сертификата

```bash
$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
$ vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
$ vault write -field=certificate pki/root/generate/internal \
> common_name="example.com" \
> ttl=87600h > ca_cert.crt
$ vault write pki/config/urls \
> issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
> crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
```

- Генерация промежуточного центра сертификации

```bash
$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
$ vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
$ vault write -format=json pki_int/intermediate/generate/internal \
> common_name="example.com Intermediate Authority" \
> | jq -r '.data.csr' > pki_intermediate.csr
$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
> format=pem_bundle ttl="43800h" \
> | jq -r '.data.certificate' > intermediate.cert.pem
$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
```
- Создание профиля для сертификата и выпуск

```bash
$ vault write pki_int/roles/example-dot-com \
> allowed_domains="example.com" \
> allow_subdomains=true \
> max_ttl="720h"
Success! Data written to: pki_int/roles/example-dot-com

$ json_crt=`vault write -format=json pki_int/issue/example-dot-com common_name="test.example.com" ttl="720h"`
$ echo $json_crt|jq -r '.data.certificate'>test.example.com.crt
$ echo $json_crt|jq -r '.data.private_key'>test.example.com.key
$ sudo cp ca_cert.crt /usr/local/share/ca-certificates/
$ sudo update-ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
```
- Установка и настройка сервера nginx

```bash
$ sudo apt install nginx
$ sudo ufw app list
Available applications:
  Nginx Full
  Nginx HTTP
  Nginx HTTPS
  OpenSSH
$ sudo ufw allow 'Nginx Full'
Rules updated
Rules updated (v6)
$ systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-03-04 14:34:56 UTC; 35s ago
       Docs: man:nginx(8)
   Main PID: 2975 (nginx)
      Tasks: 3 (limit: 1112)
     Memory: 5.1M
     CGroup: /system.slice/nginx.service
             ├─2975 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─2976 nginx: worker process
             └─2977 nginx: worker process
```

- Копируем сертификат и ключ в папку /etc/nginx/ssl. Прописываем пути до файлов в конфигурации

```bash
$ sudo mkdir /etc/nginx/ssl
$ sudo cp test.example.com.crt /etc/nginx/ssl
$ sudo cp test.example.com.key /etc/nginx/ssl
$ sudo nano /etc/nginx/sites-enabled/default
# Добавление данных в файл
listen 443 ssl default_server;
server_name       test.example.com;
ssl_certificate     /etc/nginx/ssl/test.example.com.crt;
ssl_certificate_key /etc/nginx/ssl/test.example.com.key;

$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
$ sudo systemctl restart nginx
```

- Скрипт генерации нового сертификата

```bash
#!/usr/bin/env bash
json_cert=`vault write -format=json pki_int/issue/example-dot-com common_name="test.example.com" ttl="720h"`
echo $json_cert|jq -r '.data.certificate'>test.example.com.crt
echo $json_cert|jq -r '.data.private_key'>test.example.com.key
sudo cp test.example.com.crt /etc/nginx/ssl
sudo cp test.example.com.key /etc/nginx/ssl
sudo systemctl restart nginx
```
 
- Crontab работает

```bash
$ sudo systemctl enable cron
Synchronizing state of cron.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable cron

# Запуск настроен на 06:00 каждое 8е число месяца, 
# т.к. предыдущий сертификат был выпущен 8го числа (см. скрины ниже)
$ crontab -l
.....
# m h  dom mon dow   command
0 6 8 * * /home/vagrant/cert_update.sh
```
Первый сертификат, выпущенный в 20:10

![alt text](https://user-images.githubusercontent.com/93088132/157435340-c30b191e-8901-4992-bcd9-c98e82d51ffe.png)

Второй сертификат, выпущенный в 20:12

![alt tag](https://user-images.githubusercontent.com/93088132/157435348-21338ae5-a49c-4779-9b6d-be31b07b2905.png)