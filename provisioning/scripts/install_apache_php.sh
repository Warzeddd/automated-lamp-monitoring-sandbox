#!/bin/bash

# Installer Apache2
echo "Installation d'Apache2..."
sudo apt install -y apache2 || { echo "Échec de l'installation d'Apache2"; exit 1; }
sudo systemctl enable apache2 || { echo "Échec de l'activation d'Apache2"; exit 1; }
sudo systemctl start apache2 || { echo "Échec du démarrage d'Apache2"; exit 1; }
echo "Apache2 installé et démarré avec succès."

# Installer PHP et les modules nécessaires
echo "Installation de PHP et des modules nécessaires..."
sudo apt install -y php libapache2-mod-php php-mysql php-cli php-curl php-mbstring || { echo "Échec de l'installation de PHP et des modules"; exit 1; }

# Redémarrer Apache2 pour prendre en compte les nouvelles configurations PHP
sudo systemctl restart apache2 || { echo "Échec du redémarrage d'Apache2"; exit 1; }

echo "PHP installé et configuré avec succès."

