#!/bin/bash

# Affichage de début de l'installation
echo "Starting all installations..."

# Mise à jour des paquets système avant installation
echo "Updating system packages..."
sudo apt update -y || { echo "Failed to update packages. Exiting."; exit 1; }

# Installer Apache, PHP, et MySQL
echo "Installing Apache, PHP, and MySQL..."
bash /vagrant/scripts/install/install_apache_php.sh || { echo "Failed to install Apache and PHP. Exiting."; exit 1; }
bash /vagrant/scripts/install/install_mysql.sh || { echo "Failed to install MySQL. Exiting."; exit 1; }

# Installer Monit et Supervisor
echo "Installing Monit and Supervisor..."
bash /vagrant/scripts/install/install_monit_supervisor.sh || { echo "Failed to install Monit and Supervisor. Exiting."; exit 1; }

# # Installer et Setup Postfix
# echo "Installing and Setup Postfix..."
# bash /vagrant/scripts/install/setup_postfix.sh || { echo "Failed to install and setup Postfix. Exiting."; exit 1; }

# # Installer git-app
# echo "Installing git-app..."
# bash /vagrant/scripts/install/installgit.sh || { echo "Failed to install and setup git-app. Exiting."; exit 1; }

# Copier les configurations Monit
echo "Copying Monit configurations..."
sudo cp /vagrant/scripts/configs/monit_configs/* /etc/monit/conf-available/ || { echo "Failed to copy Monit configs. Exiting."; exit 1; }
sudo ln -sf /etc/monit/conf-available/* /etc/monit/conf-enabled/ || { echo "Failed to enable Monit configs. Exiting."; exit 1; }

# Copier les configurations Supervisor
echo "Copying Supervisor configurations..."
sudo cp /vagrant/scripts/configs/supervisor_configs/* /etc/supervisor/conf.d/ || { echo "Failed to copy Supervisor configs. Exiting."; exit 1; }

# Donner les permissions d'exécution au script de notification Email
# echo "Setting execution permissions for Email notification script..."
# sudo chmod +x /vagrant/scripts/notify_email.sh || { echo "Failed to set execution permissions for Email notification script. Exiting."; exit 1; }

# Supprimer les liens symboliques dans /etc/monit/conf-enabled/ pour les configurations désactivées
sudo rm /etc/monit/conf-enabled/snmpd
sudo rm /etc/monit/conf-enabled/smartmontools
sudo rm /etc/monit/conf-enabled/rsyslog
sudo rm /etc/monit/conf-enabled/postfix
sudo rm /etc/monit/conf-enabled/pdns-recursor
sudo rm /etc/monit/conf-enabled/openssh-server
sudo rm /etc/monit/conf-enabled/openntpd
sudo rm /etc/monit/conf-enabled/nginx
sudo rm /etc/monit/conf-enabled/memcached
sudo rm /etc/monit/conf-enabled/mdadm
sudo rm /etc/monit/conf-enabled/at


# Redémarrer les services pour appliquer les configurations
echo "Restarting services..."
sudo systemctl restart apache2 || { echo "Failed to restart Apache2. Exiting."; exit 1; }
sudo systemctl restart mysql || { echo "Failed to restart MySQL. Exiting."; exit 1; }
sudo systemctl restart monit || { echo "Failed to restart Monit. Exiting."; exit 1; }
sudo systemctl restart supervisor || { echo "Failed to restart Supervisor. Exiting."; exit 1; }

# Affichage de fin de l'installation
echo "All services installed and configured successfully!"
