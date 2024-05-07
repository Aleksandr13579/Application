# Nginx

* nginx version = 1.26.0
* debian version = Debian GNU/Linux 12x
* ubuntu version = Ubuntu 24.04 LTS
* redhat version = Red Hat Enterprise Linux release 8.6 (Ootpa)

## Ycтановка
### Rhel (запустить под sudo RHEL_install.sh)
1) Добавляем репозиторий для стабильной версии nginx
2) Устанвливаем nginx
3) Открываем http и https порты на фаерволе

### Ubuntu (запустить под sudo UBUNTU_install.sh)
1) Устанавливаем пакеты, необходимые для подключения apt-репозитория
2) Импортируем официальный ключ, используемый apt для проверки подлинности пакетов
3) Проверка ключа
4) Подключаем apt-репозитория для стабильной версии nginx
5) Установка nginx

### Debian (запустить под sudo DEBIAN_install.sh)
1) Устанавливаем пакеты, необходимые для подключения apt-репозитория
2) Импортируем официальный ключ, используемый apt для проверки подлинности пакетов
3) Проверка ключа
4) Подключаем apt-репозитория для стабильной версии nginx
5) Установка nginx

---
## Настройка
### 1) Настройка ядра Linux
файл sysctl/777-propetries-for-nginx.conf
* Защита от smurf-атак
    net.ipv4.icmp_echo_ignore_broadcasts = 1
* Защита от неправильных ICMP-сообщений
    net.ipv4.icmp_ignore_bogus_error_responses = 1
* Защита от SYN-флуда (большого количества SYN-запросов (запросов на подключение по протоколу TCP) в достаточно короткий срок)
    net.ipv4.tcp_syncookies = 1
* Запрещаем маршрутизацию от источника
    net.ipv4.conf.all.accept_source_route = 0
    net.ipv4.conf.default.accept_source_route = 0
* Защита от спуфинга
    net.ipv4.conf.all.rp_filter = 1
    net.ipv4.conf.default.rp_filter = 1
*  Мы не маршрутизатор
    net.ipv4.ip_forward = 0
    net.ipv4.conf.all.send_redirects = 0
    net.ipv4.conf.default.send_redirects = 0
* Включаем ExecShield (защиту против: 1) переполнений stack'а и буфера; 2) других видов эксплоитов, которые выполняют перезапись данных в структурах или изменяют код таких структур)
    kernel.exec-shield = 1
    kernel.randomize_va_space = 1
* Расширяем диапазон доступных портов
    net.ipv4.ip_local_port_range = 2000 65000
* Увеличиваем максимальный размер TCP-буферов
    net.ipv4.tcp_rmem = 4096 87380 8388608
    net.ipv4.tcp_wmem = 4096 87380 8388608
    net.core.rmem_max = 8388608
    net.core.wmem_max = 8388608
    net.core.netdev_max_backlog = 5000
    net.ipv4.tcp_window_scaling = 1

### 2) Конфигурироване nginx
*  Конфиг + комментарии в файле nginx.conf

### 3) кэш Nginx в RAM
* Можно значительно ускорить кэш, если смонтировать его не в файловую систему а в RAM. 
Для этого также создаем папку для кэша (напрмер /var/nginx/cache), можно использовать ту же, но ее нужно очистить от папок. Далее монтируем созданный каталог в RAM с помощью команды tmpfs, выделяя 256 мегабайт под кэш:

| № | Наименование                                                                                              |Команда|
|---|-----------------------------------------------------------------------------------------------------------|-------|
| 1 | Монтирование каталога к кешом в RAM                                                                       |sudo mount -t tmpfs -o size=256M tmpfs /var/nginx/cache|
| 2 | Чтобы автоматически пересоздать каталог кеша в RAM после перезагрузки, нам нужно обновить файл /etc/fstab |tmpfs /var/nginx/cache tmpfs defaults,size=256M 0 0|
| 3 | Отключение RAM-кеш                                                                                        |sudo umount /var/nginx/cache|

### 4) Настройка SSL
* Выпуск csr из req (пример в каталоге ssl) для дальнейшего подписания 

  | № | Действие                                    |Описание| 
  |---|---------------------------------------------|-------|
  | 1 | Создаем приватный ключ                      |openssl genrsa -out new_tls.key 2048|
  | 2 | Формируем CSR (Certificate Signing Request) |openssl req -new -key new_tls.key -out new_tls.csr -config req.conf|
  | 3 | Формируем Root сертификат                   |openssl req -x509 -sha256 -nodes -new -key new_tls.key -out new_tls.crt -config req.conf     |
  | 4 | Формируем подписанный сертфикат             | openssl x509 -sha256 -CAcreateserial -req -days 365 -in new_tls.csr -extfile req.conf -CA new_tls.crt -CAkey new_tls.key -out final.crt|
