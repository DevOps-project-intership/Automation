#!/bin/bash
set -e


VAGRANT_DIR="/vagrant"
BUILD_DIR="/tmp/jenkins_package"
INSTALLER="$VAGRANT_DIR/jenkins_installer.sh"

echo "*** Preparing package directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"


# ---------------- Copy all private keys ----------------
for MACHINE in $(ls -1 "$VAGRANT_DIR/.vagrant/machines"); do
  KEY_PATH="$VAGRANT_DIR/.vagrant/machines/$MACHINE/virtualbox/private_key"

  if [[ -f "$KEY_PATH" ]]; then
    cp "$KEY_PATH" "$BUILD_DIR/private_key_$MACHINE"

  else
    echo "Warning: Private key for $MACHINE not found!"
  fi
done


# ---------------- Copy inventory.ini ----------------
if [[ -f "$VAGRANT_DIR/inventory.ini" ]]; then
  cp "$VAGRANT_DIR/inventory.ini" "$BUILD_DIR/"

else
  echo "Warning: inventory.ini not found!"
fi


# ---------------- Copy install.sh ----------------
if [[ ! -f "$VAGRANT_DIR/install.sh" ]]; then
  echo "Error: install.sh not found in $VAGRANT_DIR"
  exit 1
fi

cp "$VAGRANT_DIR/install.sh" "$BUILD_DIR/install.sh"
chmod +x "$BUILD_DIR/install.sh"


# ---------------- Install makeself if missing ----------------
if ! command -v makeself &> /dev/null; then
  sudo apt-get update -y
  sudo apt-get install -y makeself
fi


# ---------------- Generate self-extracting installer ----------------
makeself "$BUILD_DIR" "$INSTALLER" "Jenkins config installer" ./install.sh
chmod +x "$INSTALLER"

echo "*** Installer created at $INSTALLER"