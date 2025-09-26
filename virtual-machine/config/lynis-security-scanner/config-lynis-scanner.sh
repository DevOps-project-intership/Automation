#!/bin/bash


set -e  



# ---------- Install Lynis if not exists ----------
if ! command -v lynis &> /dev/null; then
    echo "[*] Installing Lynis..."
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y lynis
    else
        echo "Unsupported system!"
        exit 1
    fi
fi



# ---------- Create log directory ----------
LOG_DIR="/var/log/lynis-scans"
sudo mkdir -p "$LOG_DIR"
sudo chmod u=rwx,g+rx,o+rx "$LOG_DIR"



# ---------- Create script for running Lynis audits ----------
RUN_SCRIPT="/usr/local/bin/run-lynis-audit"
sudo tee "$RUN_SCRIPT" > /dev/null <<'EOF'
#!/bin/bash
LOG_DIR="/var/log/lynis-scans"
mkdir -p "$LOG_DIR"

# Use precise timestamp
TIMESTAMP=$(date +"%d-%m-%Y_%H-%M-%S")
LOG_FILE="$LOG_DIR/lynis-$TIMESTAMP.log"

# Run Lynis audit; log in LOG_DIR
sudo lynis audit system \
    --logfile "$LOG_FILE" \
    --no-colors \
    --quiet

echo "Lynis audit completed. Log file created: $LOG_FILE"

# Optional: copy .dat file from Lynis default location (~/.lynis) to LOG_DIR
LYNIS_DAT="$HOME/.lynis/$(basename "$LOG_FILE" .log).dat"
if [ -f "$LYNIS_DAT" ]; then
    sudo cp "$LYNIS_DAT" "$LOG_DIR/"
    echo "Dat file copied to $LOG_DIR"
fi
EOF


sudo chmod +x "$RUN_SCRIPT"



# ---------- Configure cron to run every 20 minutes ----------
CRON_JOB="*/20 * * * * /usr/local/bin/run-lynis-audit"
( sudo crontab -l 2>/dev/null | grep -v run-lynis-audit ; echo "$CRON_JOB" ) | sudo crontab -



# ---------- Run the first scan immediately ----------
echo "[*] Running initial scan..."
sudo $RUN_SCRIPT

echo "[*] Lynis setup complete. Logs will be stored in $LOG_DIR"