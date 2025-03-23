# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Скрипт ниже выполняет инициализацию схемы шардирования:
1) создает конфиг сервер (реплика из 1 инстанс - без репликации)
2) создает 2 шарда (каждый шард реплика из 1 инстанса - без репликации)
и заполняет базу тестовыми данными 

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Проверка тестовых данных в базе и распределение по шардам

в целом на сервере
```shell
docker exec -it mongos_router mongosh --port 27017 somedb --eval 'db.helloDoc.countDocuments()'
```
на каждом из шардов

```shell
docker exec -it shard1-1 mongosh --port 27018 somedb --eval 'db.helloDoc.countDocuments()'
docker exec -it shard2-1 mongosh --port 27019 somedb --eval 'db.helloDoc.countDocuments()'
```

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs
