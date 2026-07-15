#!/bin/bash

echo "Starting installation of Monit and Supervisor..."

# Installer Monit
echo "Installing Monit..."
apt-get install -y acpid monit || { echo "Échec de l'installation de Monit"; exit 1; }

# Installer Supervisor
echo "Installing Supervisor..."
apt-get install -y supervisor || { echo "Échec de l'installation de Supervisor"; exit 1; }

# Créer un dossier pour désactiver les configurations problématiques
DISABLED_CONF_DIR="/etc/monit/conf-disabled/"
ENABLED_CONF_DIR="/etc/monit/conf-enabled/"
echo "Creating disabled configuration directory: $DISABLED_CONF_DIR"
mkdir -p "$DISABLED_CONF_DIR" || { echo "Échec de la création du dossier pour les configurations désactivées"; exit 1; }

# Vérifier les fichiers dans /etc/monit/conf-enabled/ avant de tenter de les déplacer
echo "Checking configurations in $ENABLED_CONF_DIR..."
for conf in snmpd smartmontools rsyslog memcached nginx mdadm at openntpd openssh-server pdns-recursor postfix; do
    if [ -f "${ENABLED_CONF_DIR}${conf}" ]; then
        echo "Found $conf in $ENABLED_CONF_DIR"
        mv "${ENABLED_CONF_DIR}${conf}" "$DISABLED_CONF_DIR" || { echo "Impossible de déplacer $conf"; exit 1; }
        echo "Moved $conf to $DISABLED_CONF_DIR"
    else
        echo "$conf not found in $ENABLED_CONF_DIR"
    fi
done

# Activer les services au démarrage
echo "Enabling Monit and Supervisor to start on boot..."
systemctl enable monit || { echo "Échec de l'activation de Monit"; exit 1; }
systemctl enable supervisor || { echo "Échec de l'activation de Supervisor"; exit 1; }

# Démarrer les services
echo "Starting Monit and Supervisor..."
systemctl start monit || { echo "Échec du démarrage de Monit"; exit 1; }
systemctl start supervisor || { echo "Échec du démarrage de Supervisor"; exit 1; }

# Vérifier l'état des services
echo "Checking service statuses..."
systemctl status monit --no-pager
systemctl status supervisor --no-pager


echo "Monit and Supervisor installed and configured successfully!"
