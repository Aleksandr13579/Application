# Инструкция по сборке qcow2 из iso образа rhel v8.1

> Рядом с файлом rhel8.pkr.hcl положить образ rhel в формате iso. \
> В нашем случае образ называется rhel-8.1-x86_64-dvd.iso \
> Образ должен быть именно dvd, так как образы boot требуют подключения к репазиториям red hat

### Сборка
Команда для сборки:
```shell
packer build  rhel8.pkr.hcl
```


### После сборки:
1) Базовая информация об образе
    ```bash
      qemu-img info ваш_образ.qcow2
    ````

    > Формат образа<br>Виртуальный размер<br>Реальный размер на диске<br>Кластеры<br>Поддержка снимков (snapshots)

     Пример вывода:  
      ```text
        disk size: 1.48 GiB
        cluster_size: 65536
        Format specific information:
            compat: 1.1
            compression type: zlib
            lazy refcounts: false
            refcount bits: 16
            corrupt: false
            extended l2: false
        Child node '/file':
            filename: rhel-8.1-x86_64.qcow2
            protocol type: file
            file length: 1.48 GiB (1589444608 bytes)
            disk size: 1.48 GiB
      ```

2) Проверка целостности
    ```bash
    qemu-img check ваш_образ.qcow2
    ```
    > Варианты результатов:<br>No errors found - образ целый<br>Leaked cluster - возможные проблемы<br>Corrupt cluster - поврежденные данные


```shell
packer build  rhel8.pkr.hcl
```



