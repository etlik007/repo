#!/bin/bash

# Renkli çıktı için tanımlar
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root kontrolü
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Lütfen scripti root olarak çalıştırın!${NC}"
  exit 1
fi

# Sistem güncelleme
echo -e "${GREEN}Sistem güncelleniyor...${NC}"
apt update && apt upgrade -y

# Gerekli paketler
echo -e "${GREEN}Temel paketler kuruluyor...${NC}"
apt install -y curl wget git ufw software-properties-common build-essential

# Nginx kurulumu
echo -e "${GREEN}Nginx kuruluyor...${NC}"
apt install -y nginx
systemctl enable nginx
systemctl start nginx

# Certbot kurulumu (Let's Encrypt SSL için)
echo -e "${GREEN}Certbot kuruluyor...${NC}"
apt install -y certbot python3-certbot-nginx

# Python 3, pip ve venv kurulumu
echo -e "${GREEN}Python 3, pip ve venv kuruluyor...${NC}"
apt install -y python3 python3-pip python3-venv

# Node.js kurulumu (LTS)
echo -e "${GREEN}Node.js kuruluyor...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# MongoDB kurulumu
echo -e "${GREEN}MongoDB kuruluyor...${NC}"
apt install -y gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
apt update
apt install -y mongodb-org
systemctl enable mongod
systemctl start mongod

# Güvenlik duvarı (UFW) temel ayarları
echo -e "${GREEN}UFW güvenlik duvarı ayarlanıyor...${NC}"
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

# Kurulum tamamlandı
clear
echo -e "${GREEN}Tüm temel yazılımlar başarıyla kuruldu!${NC}"
echo -e "Şimdi backend ve panel kurulumuna geçebilirsiniz."
