#!/bin/bash
set -e

cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz

tar xvf node_exporter-1.8.2.linux-amd64.tar.gz

sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/

sudo useradd --no-create-home --shell /sbin/nologin node_exporter || true
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

sudo tee /etc/consul.d/node-exporter.hcl > /dev/null <<'EOF'
service {
  name = "node-exporter"
  port = 9100
  check {
    name     = "HTTP check for node-exporter"
    http     = "http://localhost:9100/metrics"
    interval = "10s"
    timeout  = "5s"
  }
}
EOF

sudo consul validate /etc/consul.d/node-exporter.hcl || true
