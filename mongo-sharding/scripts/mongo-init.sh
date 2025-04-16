#!/bin/bash

# Настраиваем сервер конфигурации
docker exec -i configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
EOF

# Настраиваем шард 1
docker exec -i shard1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" }
      ]
    }
);
EOF

# Настраиваем шард 2
docker exec -i shard2 mongosh --port 27019 <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 1, host : "shard2:27019" }
    ]
  }
);
EOF

# Делаем паузу, чтобы инициализация сервера конфигурации завершилась и шардов
sleep 7

# Инициализируем роутер, и заполняем тестовыми данными
docker exec -i mongos_router mongosh --port 27020 <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );

use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
db.helloDoc.countDocuments();
EOF

# Тестируем количество документов на шардах
echo 'shard1'
docker exec -i shard1 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

echo 'shard2'
docker exec -i shard2 mongosh --port 27019 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF
