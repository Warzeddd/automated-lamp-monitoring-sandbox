!/bin/bash

# Variables pour la configuration de Postfix
GMAIL_USERNAME="your_address@gmail.com"
GMAIL_PASSWORD="YOUR_SECURE_APP_PASSWORD"

# Installer Postfix et mailutils sendmail
sudo apt-get install -y postfix mailutils
sudo apt-get install -y libsasl2 libsasl2-modules libsasl2-modules-db

# Configuration de Postfix
echo "relayhost = [smtp.gmail.com]:587" | sudo tee -a /etc/postfix/main.cf
echo "smtp_sasl_auth_enable = yes" | sudo tee -a /etc/postfix/main.cf
echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" | sudo tee -a /etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous" | sudo tee -a /etc/postfix/main.cf
echo "smtp_use_tls = yes" | sudo tee -a /etc/postfix/main.cf

# Créer le fichier de mot de passe d'authentification
echo "[smtp.gmail.com]:587 $GMAIL_USERNAME:$GMAIL_PASSWORD" | sudo tee /etc/postfix/sasl_passwd

# Protéger le fichier de mot de passe
sudo chmod 600 /etc/postfix/sasl_passwd

# Mettre à jour la table de hashage des mots de passe
sudo postmap /etc/postfix/sasl_passwd

# Redémarrer le service Postfix
sudo systemctl restart postfix

# Tester l'envoi d'un email
SUBJECT="Test : Alerte sécurité"
BODY="Ceci est un test pour vérifier l'envoi d'un email via Gmail avec Postfix."
TO_EMAIL="calix.hoe@gmail.com"

echo "$BODY" | mail -s "$SUBJECT" "$TO_EMAIL"

echo "Test d'envoi d'email effectué."
