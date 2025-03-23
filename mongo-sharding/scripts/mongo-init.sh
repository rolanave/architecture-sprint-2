#!/bin/bash

###
# Инициализируем бд
###

#инициализируем сервер конфигурации
docker exec -it configSrv mongosh --port 27020 --eval 'rs.initiate({_id : "config_server", configsvr: true, members: [{ _id : 0, host : "configSrv:27020" }]});'


#инициализируем shard1
docker exec -it shard1-1 mongosh --port 27018 --eval 'rs.initiate ({_id : "shard1", members: [{ _id : 0, host : "shard1-1:27018" },]});'

#инициализируем shard2
docker exec -it shard2-1 mongosh --port 27019 --eval 'rs.initiate({_id : "shard2", members: [{ _id : 1, host : "shard2-1:27019" }]});'

# небольшая задержка для настройки реп
sleep 2
# настройка роутера на шарды
docker exec -it mongos_router mongosh --port 27017 --eval 'sh.addShard( "shard1/shard1-1:27018");'
docker exec -it mongos_router mongosh --port 27017 --eval 'sh.addShard( "shard2/shard2-1:27019");'

# заполним базу тестовыми данными - база somedb добавляется для шардирования и заполняется данными 
docker exec -it mongos_router mongosh --port 27017 --eval 'sh.enableSharding("somedb");'
docker exec -it mongos_router mongosh --port 27017 --eval 'sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });'
docker exec -it mongos_router mongosh --port 27017 somedb --eval 'for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});'

