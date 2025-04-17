# pymongo-api

Добавлены 3 проекта:
* mongo-sharding
* mongo-sharding-repl
* sharding-repl-cache

## Как запустить

Заходим в каждый проект и запускаем по инструкции далее.


Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными, и делаем первоначальные настройки при первом запуске

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

## Схема архитектуры

Схема находится в корне проекта [sp2.drawio](./sp2.drawio)