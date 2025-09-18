#!/bin/bash


IP_SUBNET="127.0.0.1/32"
CONFIG_FILE="/etc/postgresql/17/main/postgresql.conf"
HBA_FILE="/etc/postgresql/17/main/pg_hba.conf"
TARGET_LINE="host    all             all"
AUTH_METHOD="scram-sha-256"


# Parse flags/argument
while [[ $# -gt 0 ]]; do
    case "$1" in
        --ip)
            IP_SUBNET="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done



# Update and install PostgreSQL server
sudo apt update
sudo apt install -y postgresql


PSQL_DOES_EXISTS=$(psql --version)

if [[ $PSQL_DOES_EXISTS == *"psql (PostgreSQL)"* ]]; then

    STATUS=$(sudo systemctl status postgresql)

    if [[ $STATUS == *"Active: inactive (dead)"* && $STATUS == *"disabled; "* ]]; then
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
        echo "Active::Enable"

    elif [[ $STATUS == *"Active: inactive (dead)"* && $STATUS == *"enabled; "* ]]; then
        sudo systemctl start postgresql
        echo "Active: inactive (dead) ------> Active: active (exited)"

    elif [ $STATUS == *"Active: active (exited)"* && $STATUS == *"disabled; "* ]]; then
        sudo systemctl enable postgresql
        echo "Loaded: disable ------> Load enable"

    fi

fi



# Edit configuration posgresql file to change listen on all ip-addresses from localhost 
# Check if a line starting with "host all all" exists
if grep -qE "^host\s+all\s+all" "$HBA_FILE"; then

    # Replace the IP/network part with IP_SUBNET and normalize spacing
    sudo sed -i -E "s|^host\s+all\s+all\s+[0-9./]+(\s+.*)|host    all    all    $IP_SUBNET\1|" "$HBA_FILE"
    echo "Updated pg_hba.conf subnet: $IP_SUBNET"

else
    # If no such line exists, add it at the end with proper spacing
    echo -e "host    all    all    $IP_SUBNET    $AUTH_METHOD" | sudo tee -a "$HBA_FILE" > /dev/null
fi


# restart postgreSQL service
sudo systemctl restart postgresql