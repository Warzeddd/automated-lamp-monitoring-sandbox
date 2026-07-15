#!/bin/bash

echo "Starting MariaDB installation..."

# Installer MariaDB depuis les dépôts Debian
echo "Installing MariaDB..."
sudo apt install -y mariadb-server

# Activer et démarrer le service MariaDB
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Configuration de MariaDB (optionnelle, vous pouvez décommenter la ligne suivante si vous voulez l'exécuter)
# echo "Configuring MariaDB..."
# sudo mysql_secure_installation

echo "MariaDB installed and configured successfully."
