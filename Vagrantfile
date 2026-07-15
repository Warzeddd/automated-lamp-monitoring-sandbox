# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Spécification de la box de base Debian
  config.vm.box = "debian/bookworm64"
  config.vm.box_version = "12.20240905.1"

  # Configuration réseau
  # Redirection de port pour l'accès aux services
  config.vm.network "forwarded_port", guest: 3000, host: 3000  # Port pour un service web (par ex. Node.js)
  config.vm.network "forwarded_port", guest: 8000, host: 8000  # Port pour un autre service web
  config.vm.network "forwarded_port", guest: 3306, host: 3306  # Port pour MySQL

  # Réseau privé, l'adresse IP utilisée pour la machine virtuelle
  config.vm.network "private_network", ip: "192.168.33.10"

  # Synchronisation de dossier entre l'hôte et la machine virtuelle
  config.vm.synced_folder "app/", "/var/www/html"

  # Configuration de la machine virtuelle VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"  # 2 Mo de mémoire pour la VM
    vb.cpus = 2         # 2 cœurs de CPU alloués
  end

  # Provisionner avec le script d'installation
  config.vm.provision "shell", path: "install_all.sh"

  # Exécution de Monit et Supervisor comme services système
  config.vm.provision "shell", inline: <<-SHELL
    # Activer et démarrer les services Monit et Supervisor
    sudo systemctl enable monit
    sudo systemctl enable supervisor
    sudo systemctl start monit
    sudo systemctl start supervisor
  SHELL

  # Triggers
  # config.trigger.before :destroy do |t|
  #   t.info = "Sauvegarde de la base de données..."
  #   t.run = { inline: "/vagrant/scripts/mysqldump.sh" }
  # end
  
  config.trigger.before :up do |t|
    t.info = "La machine va démarrer"
  end
  
  config.trigger.after :halt do |t|
    t.info = "La machine a été arrêtée"
  end
  
  config.trigger.after :provision do |t|
    t.info = "Reboot Apache"
    t.run = { inline: "sudo systemctl reload apache2" }
  end
  
end
