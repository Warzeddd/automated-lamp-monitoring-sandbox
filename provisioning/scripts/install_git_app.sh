#!/bin/bash
set -e

echo "Début de l'installation de Git et clonage du dépôt..."

sudo apt-get install -y git

url_clone="https://github.com/banago/simple-php-website.git"

git clone $url_clone app/

echo "Git est installé et le dépôt a été cloné avec succès !"

