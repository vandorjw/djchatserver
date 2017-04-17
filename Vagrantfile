# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "web" do |web|
    web.vm.box = "debian/jessie64"
    web.vm.hostname = "web"
    web.vm.box_url = "debian/jessie64"

    web.vm.network :private_network, ip: "10.0.0.101"

    config.vm.synced_folder ".", "/home/vagrant/project"

    web.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "512"
    end

    $SERVER_SETUP = <<-SCRIPT
      export DEBIAN_FRONTEND=noninteractive
      apt-get update && apt-get build-dep -y psycopg2
      apt-get update && apt-get build-dep python-pygraphviz -y
      apt-get update && apt-get install -y --no-install-recommends \
      git \
      postgresql-client \
      build-essential \
      apt-transport-https \
      ca-certificates \
      gnupg \
      libssl-dev \
      libffi-dev \
      curl \
      git \
      libpq-dev \
      python3-dev \
      python3.4-venv \
      python3-setuptools \
      openssh-client
      apt-get autoremove
      apt-get clean
      rm -rf /var/lib/apt/lists/*
    SCRIPT

    $VIRTUALENV_SETUP = <<-SCRIPT
      export PYTHONUNBUFFERED=1
      python3 -m venv venv
      source venv/bin/activate
      pip install pip --upgrade
      pip install setuptools --upgrade
      pip install -r /home/vagrant/project/requirements.txt
    SCRIPT

    web.vm.provision "shell", inline: $SERVER_SETUP, privileged: true
    web.vm.provision "shell", inline: $VIRTUALENV_SETUP, privileged: false

  end

  config.vm.define "db" do |db|
    db.vm.box = "debian/jessie64"
    db.vm.hostname = "db"
    db.vm.box_url = "debian/jessie64"

    db.vm.network :private_network, ip: "10.0.0.102"

    db.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "512"
    end

    $SERVER_SETUP = <<-SCRIPT
      export DEBIAN_FRONTEND=noninteractive
      apt-get update && apt-get install -y --no-install-recommends \
      postgresql \
      postgresql-contrib
      apt-get autoremove
      apt-get clean
      rm -rf /var/lib/apt/lists/*
    SCRIPT

    $DATABASE_SETUP = <<-SCRIPT
      sudo -u postgres psql -c "CREATE ROLE dev WITH LOGIN SUPERUSER PASSWORD 'dev';"
      sudo -u postgres psql -c "CREATE DATABASE dev WITH OWNER dev;"
    SCRIPT

    db.vm.provision "shell", inline: $SERVER_SETUP, privileged: true
    db.vm.provision "shell", inline: $DATABASE_SETUP, privileged: false
  end

end
