#!/bin/bash

# Простой скрипт для деплоя без Kamal
set -e

echo "🚀 Начинаем ручной деплой..."

# Переменные
IMAGE_NAME="dave2281/time_tracker2"
SERVER="164.92.182.94"
PASSWORD="5NM~.\t@T;#BI7L\$+QHuRE3B@IJRY\\*1c"
CONTAINER_NAME="time_tracker2"

echo "📦 Собираем Docker образ..."
sudo docker build -t $IMAGE_NAME .

echo "📤 Загружаем образ в Docker Hub..."
sudo docker push $IMAGE_NAME

echo "🖥️  Деплоим на сервер..."
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@$SERVER << EOF
# Останавливаем и удаляем старый контейнер если есть
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Загружаем новый образ
docker pull $IMAGE_NAME

# Запускаем новый контейнер
docker run -d \\
  --name $CONTAINER_NAME \\
  -p 80:80 \\
  -p 443:443 \\
  -v time_tracker2_storage:/rails/storage \\
  -e RAILS_MASTER_KEY=c08a6cccd9edb771a12a681ecf23f2b2 \\
  -e RAILS_ENV=production \\
  $IMAGE_NAME

echo "✅ Контейнер запущен!"
docker ps | grep $CONTAINER_NAME
EOF

echo "🎉 Деплой завершен! Приложение доступно на http://$SERVER"