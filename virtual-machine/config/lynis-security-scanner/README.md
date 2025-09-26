# PostgreSQL Auto Setup Script with Lynis Security Audit

This Bash script automates the **installation, startup, and initial configuration of PostgreSQL** on **Debian/Ubuntu-based Linux systems**, alongside **installing and setting up Lynis** for regular system security audits.

- **PostgreSQL** setup includes configuring database access from a specific IP/subnet and enforcing `scram-sha-256` authentication.
- **Lynis** is automatically installed (if not present) and configured to run security audits every 20 minutes, storing the logs in a designated directory.

## 📌 Features

### PostgreSQL Setup
1. **Installs PostgreSQL** if not already installed:
    ```bash
    sudo apt update
    sudo apt install -y postgresql
    PSQL_DOES_EXISTS=$(psql --version)
    if [[ $PSQL_DOES_EXISTS == *"psql (PostgreSQL)"* ]]; then
        ...
    fi
    ```

2. **Checks PostgreSQL service status**:
   - If inactive and disabled → starts and enables the service:
     ```bash
     if [[ $STATUS == *"Active: inactive (dead)"* && $STATUS == *"disabled; "* ]]; then
         sudo systemctl start postgresql
         sudo systemctl enable postgresql
         echo "Active::Enable"
     fi
     ```
   - If disabled on boot → enables the service:
     ```bash
     elif [[ $STATUS == *"Active: inactive (dead)"* && $STATUS == *"enabled; "* ]]; then
         sudo systemctl start postgresql
         echo "Active: inactive (dead) ------> Active: active (exited)"
     ```
   - If stopped → starts and enables the service:
     ```bash
     elif [ $STATUS == *"Active: active (exited)"* && $STATUS == *"disabled; "* ]]; then
         sudo systemctl enable postgresql
         echo "Loaded: disable ------> Load enable"
     ```

3. **Edits `pg_hba.conf`** to allow access from a specific IP or subnet:
   - Updates or appends the appropriate `host all all ...` entry with the proper subnet:
     ```bash
     sudo sed -i -E "s|^host\s+all\s+all\s+[0-9./]+(\s+.*)|host    all    all    $IP_SUBNET\1|" "$HBA_FILE"
     ```

4. **Restarts PostgreSQL** automatically to apply changes.

### Lynis Security Audit
1. **Installs Lynis** if not already installed:
    ```bash
    sudo apt install -y lynis
    ```

2. **Creates a directory** for Lynis logs:
    ```bash
    LOG_DIR="/var/log/lynis-scans"
    sudo mkdir -p "$LOG_DIR"
    sudo chmod u=rwx,g+rx,o+rx "$LOG_DIR"
    ```

3. **Creates a script** to run Lynis audits and logs results:
    ```bash
    sudo tee "$RUN_SCRIPT" > /dev/null <<'EOF'
    ...
    EOF
    ```

4. **Schedules Lynis audit** to run every 20 minutes:
    ```bash
    CRON_JOB="*/20 * * * * /usr/local/bin/run-lynis-audit"
    ( sudo crontab -l 2>/dev/null | grep -v run-lynis-audit ; echo "$CRON_JOB" ) | sudo crontab -
    ```

5. **Runs an initial Lynis scan** immediately after setup.

---

## ⚙️ Requirements
- **Operating System**: Debian / Ubuntu
- **Administrator Privileges**: `sudo` and Lynis packages.

---

## 🚀 Usage

### 1. Make the script executable
```bash
chmod +x setup_postgres_lynis.sh
```

### 2. Verify the setup
```bash
/var/log/lynis-scans/
```