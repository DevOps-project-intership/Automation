#!/bin/bash
[ "$#" -eq 0 ] && exit 1

sudo apt update -y
sudo apt install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx


sudo rm -f /etc/nginx/conf.d/default.conf
sudo rm -f /etc/nginx/sites-enabled/default

sudo tee /etc/nginx/ip_addresses.list >/dev/null <<EOF
$(for addr in "$@"; do echo "server $addr;"; done)
EOF

sudo tee /etc/nginx/conf.d/lb.conf >/dev/null <<'EOF'
upstream birdwatching {
    include /etc/nginx/ip_addresses.list;
}
server {
    listen 80 default_server;
    location / { proxy_pass http://birdwatching; }
}
EOF

sudo nginx -t && sudo systemctl reload nginx

sudo apt install python3
sudo apt install python3-flask
