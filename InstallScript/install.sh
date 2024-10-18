#!/bin/bash
#
# NGinX Section
#

# Install nginx
apt update
apt install -y epel-release
apt install -y nginx
apt install -y unzip
apt install -y firewalld

curl -s https://deb.nodesource.com/setup_18.x | sudo bash
apt install -y nodejs

#apt install -y ca-certificates curl gnupg
#mkdir -p /etc/apt/keyrings
#curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
#echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
#apt update
#apt install -y nodejs
apt install -y npm
apt install -y git

# Create the /var/www directory if it doesn't exist
mkdir -p /var/www
mkdir -p /var/www/App

systemctl restart nginx

# Open HTTP port 80 in the firewall
systemctl stop firewalld
firewall-offline-cmd --zone=public --add-service=http
firewall-offline-cmd --zone=public --add-service=https
firewall-offline-cmd --zone=public --add-port=3000/tcp 
# firewall-cmd --reload
systemctl start firewalld

cd /var/www
wget https://github.com/juice-shop/juice-shop/releases/download/v17.1.1/juice-shop-17.1.1_node18_linux_x64.tgz
tar zxvf juice-shop-17.1.1_node18_linux_x64.tgz 
mv juice-shop_17.1.1 juice-shop
cd juice-shop
chmod 777 data/ -R

# Create Kestral service for the asp.net application
echo '
[Unit]
Description=Juice-shop application

[Service]

ExecStart=npm start --prefix=/var/www/juice-shop
RestartSec=10
Restart=always

StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=juice-shop

Environment=PATH=/usr/bin:/usr/local/bin

[Install]
WantedBy=multi-user.target
' | tee /etc/systemd/system/juice-shop.service

systemctl enable juice-shop.service
systemctl start juice-shop.service

# Configure nginx to serve juice shop
#mkdir -p /etc/nginx/sites-available
#
echo '
server {
    listen       80;
    server_name  _;
    location / {
        proxy_pass         http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }
}
' | tee /etc/nginx/sites-available/default

systemctl restart nginx





