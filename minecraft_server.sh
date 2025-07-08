#!/bin/bash

echo "📦 Tạo thư mục server..."
mkdir -p ~/mc-server
cd ~/mc-server || exit

echo "☕ Kiểm tra Java..."
if ! command -v java &> /dev/null; then
  echo "❌ Java chưa cài. Thoát script."
  exit 1
fi

echo "⬇️ Tải Minecraft Server 1.20.1..."
wget -O server.jar https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar

echo "✅ Chấp nhận EULA..."
echo "eula=true" > eula.txt

echo "🚀 Khởi động server lần đầu để tạo file..."
java -Xmx2G -Xms1G -jar server.jar nogui &
sleep 10
pkill -f server.jar

echo "🌐 Kiểm tra ngrok..."
if ! command -v ngrok &> /dev/null; then
  echo "📦 Cài ngrok..."
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip
  unzip ngrok-stable-linux-amd64.zip
  sudo mv ngrok /usr/local/bin
fi

echo "🔐 Kiểm tra cấu hình ngrok..."
if ! grep -q "authtoken" ~/.config/ngrok/ngrok.yml 2>/dev/null; then
  echo "⚠️ Ngrok chưa cấu hình authtoken. Vui lòng vào https://dashboard.ngrok.com/get-started/setup để lấy token."
  read -rp "➡️ Nhập authtoken: " TOKEN
  ngrok config add-authtoken "$TOKEN"
fi

echo "🔓 Mở port 25565 với ngrok..."
cd ~/mc-server || exit
gnome-terminal -- bash -c "ngrok tcp 25565; exec bash" &

sleep 3
echo "📍 Địa chỉ kết nối (IP sẽ hiện trong cửa sổ ngrok bên cạnh, dạng tcp://...:port)."
echo "🎉 Gửi địa chỉ đó cho bạn bè để vào server!"

echo "✅ Đang khởi động lại Minecraft server..."
java -Xmx2G -Xms1G -jar server.jar nogui
