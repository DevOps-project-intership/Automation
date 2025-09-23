#!/bin/bash
set -e


INSTALL_DIR="/home/jenkins"
KEYS_DIR="$INSTALL_DIR/keys"

echo "*** Installing Jenkins config..."
mkdir -p "$KEYS_DIR"


# ---------------- Install all private keys ----------------
for KEY in private_key_*; do
  if [[ -f "$KEY" ]]; then
    cp "$KEY" "$KEYS_DIR/$KEY"
    chmod 600 "$KEYS_DIR/$KEY"
    echo "  -> Installed $KEY into $KEYS_DIR"
  fi
done


# ---------------- Install inventory.ini ----------------
if [[ -f "inventory.ini" ]]; then
  cp inventory.ini "$INSTALL_DIR/inventory.ini"
  chmod 644 "$INSTALL_DIR/inventory.ini"
  echo "  -> Installed inventory.ini into $INSTALL_DIR"
fi

echo "*** Done!"