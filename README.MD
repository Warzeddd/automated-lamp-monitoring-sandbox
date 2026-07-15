# Self-Healing & Automated LAMP Infrastructure Sandbox

Environnement d'Infrastructure as Code (IaC) local basé sur Vagrant et VirtualBox, automatisant le déploiement d'une pile d'applications LAMP (Debian 12) hautement résiliente grâce à l'implémentation de processus auto-cicatrisants (*self-healing*), de monitoring proactif et d'alerting SMTP.

---

## 🏗️ Spécifications de l'Infrastructure et des Services

* **Hyperviseur & OS** : Machine virtuelle Debian 12 (Bookworm) virtualisée de manière déclarative via Vagrant (fournisseur VirtualBox).
* **Réseau privé** : Isolation logique de la VM sur l'adresse IP statique `192.168.33.10` avec redirection dynamique des ports applicatifs (`8000`, `3306`).
* **Serveur Web & SGBD** : Pile Apache2, PHP 8.x et MariaDB hautement configurés.

---

## 🛡️ Résilience, Ordonnancement & Auto-Cicatrisation

L'intérêt principal de ce laboratoire est la mise en place d'un mécanisme de tolérance aux pannes applicatives de niveau production :

### 1. Supervision active avec Monit
Monit est implémenté en tant que démon de surveillance locale. Il analyse de manière synchrone les sockets réseau et l'état des descripteurs de fichiers système :
* **Surveillance d'Apache2 & MariaDB** : Monit vérifie l'accès au port TCP `80` (protocole HTTP) et `3306`.
* **Cycle d'auto-cicatrisation** : Si l'un des démons s'arrête ou ne répond plus aux requêtes transactionnelles, Monit intercepte la panne et exécute automatiquement une commande corrective de restauration (`systemctl restart`).
* **Alerte de dernier recours** : Si le service échoue à redémarrer après 5 tentatives consécutives au cours de 5 cycles de vérification, Monit désactive temporairement l'action et notifie l'administrateur via un relais SMTP de secours.

### 2. Contrôle de Processus au Premier Plan avec Supervisor
Afin d'éviter le contournement des descripteurs d'état par l'utilisation de scripts d'init obsolètes ou d'échappements de processus de type *orphan zombie*, Supervisor est déployé pour gérer les démons critiques en tâche de fond (`FOREGROUND`) :
* Commande Apache2 contrôlée : `/usr/sbin/apache2ctl -D FOREGROUND`
* Commande MariaDB contrôlée : `/usr/sbin/mysqld`
* Redémarrage immédiat (`autorestart=true`) en cas d'interruption du signal système Unix.

### 3. Résilience et Cycle de vie de la Donnée (Triggers Vagrant)
La préservation de l'état de la base de données est directement intégrée aux étapes d'administration système grâce aux déclencheurs (*Triggers*) déclarés au sein du `Vagrantfile` :
* **Hook Pré-Destruction** (`before :destroy`) : Avant la suppression de l'hôte virtuel, un script automatisé exécute un `mysqldump` pour archiver et persister l'état de la base de données relationnelle locale (`init_db.sql`) dans le dossier partagé persistant de la machine hôte.

---

## 📬 Système d'Alerte SMTP (Postfix Relay via SASL)

L'infrastructure intègre une passerelle de messagerie légère via Postfix configurée pour relayer les notifications Monit vers l'extérieur :
* **Relais SMTP Externe** : Configuration de Postfix (`main.cf`) pointant sur le serveur de transport de confiance Google (`[smtp.gmail.com]:587`).
* **Durcissement d'accès** : Stockage chiffré et restreint (`chmod 600`) des identifiants d'authentification réseau sécurisés par chiffrement d'empreintes via la table de hachage SASL (`sasl_passwd` mis à jour par `postmap`).

---

## 📂 Organisation des Livrables

```text
.
├── app/                         # Code source de l'application PHP hébergée
├── database/                    # Schémas SQL et sauvegardes automatiques à chaud (Hot Backups)
├── provisioning/                # Configuration et scripts de déploiement IaC
│   ├── configs/                 # Fichiers de configuration des agents
│   │   ├── monit/               # Définitions des sondes d'auto-cicatrisation (Apache/MariaDB)
│   │   └── supervisor/          # Politiques de maintien des processus au premier plan
│   └── scripts/                 # Scripts d'installation modulaires (LAMP, Monitoring, Postfix Relay)
└── Vagrantfile                  # Configuration déclarative globale de la VM et des hooks d'automatisation
