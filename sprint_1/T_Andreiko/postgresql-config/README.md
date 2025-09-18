# PostgreSQL Auto Setup Script



This Bash script automates the **installation, startup, and initial configuration of PostgreSQL** on Debian/Ubuntu-based Linux systems
It allows you to quickly configure database access from a specific IP address or subnet, and enforces the modern `scram-sha-256` authentication method.

---




## 📌 Features
1. **Installs PostgreSQL** (if not already installed).
    ```bash
    sudo apt update
    sudo apt install -y postgresql
    PSQL_DOES_EXISTS=$(psql --version)
    if [[ $PSQL_DOES_EXISTS == *"psql (PostgreSQL)"* ]]; then
        ...
    fi
2. **Checks PostgreSQL service status**:
   - if inactive and disable → does start and enable:
        ```bash
        if [[ $STATUS == *"Active: inactive (dead)"* && $STATUS ==         *"disabled; "* ]]; then
            sudo systemctl start postgresql
            sudo systemctl enable postgresql
            echo "Active::Enable"
        fi
   - if disabled on boot → enables it:
        ```bash
        elif [[ $STATUS == *"Active: inactive (dead)"* && $STATUS == *"enabled; "* ]]; then
            sudo systemctl start postgresql
            echo "Active: inactive (dead) ------> Active: active (exited)"
    - if stopped → starts the service:
        ```bash
        elif [ $STATUS == *"Active: active (exited)"* && $STATUS == *"disabled; "* ]]; then
        sudo systemctl enable postgresql
        echo "Loaded: disable ------> Load enable"
3. **Edits `pg_hba.conf`**:
   - if a `host all all ...` entry exists → updates the subnet;
   - if no such entry → appends a new line with proper spacing
   ```bash 
    sudo sed -i -E "s|^host\s+all\s+all\s+[0-9./]+(\s+.*)|host    all    all    $IP_SUBNET\1|" "$HBA_FILE"
4. **Automatically restarts PostgreSQL** to apply changes.
5. Flexible configuration via command-line arguments.

---




## ⚙️ Requirements
- Operating System: **Debian / Ubuntu**
- Administrator privileges (**sudo**)
- Internet connection (to install PostgreSQL package)

---

## 🚀 Usage

### 1. Make it executable
```bash
chmod +x setup_postgres.sh
