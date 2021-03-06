# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  config.vm.define "web", primary: true do |web|
    web.vm.box = "debian/contrib-jessie64"
    web.vm.hostname = "web"
    web.vm.box_url = "debian/contrib-jessie64"

    web.vm.network :private_network, type: "dhcp"
    web.vm.network :forwarded_port, guest: 8000, host: 8000

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

    $DJANGO_AUTOSTART = <<-SCRIPT
      export DEBIAN_FRONTEND=noninteractive
      sudo cp /home/vagrant/django.service /etc/systemd/system/django.service
      rm /home/vagrant/django.service
    SCRIPT

    web.vm.provision "shell", inline: $SERVER_SETUP, privileged: true
    web.vm.provision "shell", inline: $VIRTUALENV_SETUP, privileged: false
    web.vm.provision "file", source: "./vagrant.d/web/django.service", destination: "~/django.service"

  end

  config.vm.define "db" do |db|
    db.vm.box = "debian/contrib-jessie64"
    db.vm.hostname = "db"
    db.vm.box_url = "debian/contrib-jessie64"

    db.vm.network :private_network, type: "dhcp"
    db.vm.network :forwarded_port, guest: 5432, host: 5432

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

  config.vm.define "redis" do |redis|
    redis.vm.box = "debian/contrib-jessie64"
    redis.vm.hostname = "redis"
    redis.vm.box_url = "debian/contrib-jessie64"

    redis.vm.network :private_network, type: "dhcp"
    redis.vm.network :forwarded_port, guest: 6379, host: 6379

    redis.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "512"
    end

    $SERVER_SETUP = <<-SCRIPT
      export DEBIAN_FRONTEND=noninteractive
      apt-get update && apt-get install -y --no-install-recommends \
      redis-server
      apt-get autoremove
      apt-get clean
      rm -rf /var/lib/apt/lists/*
    SCRIPT

    $CONFIGURE_REDIS = <<-SCRIPT
      export DEBIAN_FRONTEND=noninteractive
      sudo cp /home/vagrant/redis.conf /etc/redis/redis.conf
      rm /home/vagrant/redis.conf
    SCRIPT

    redis.vm.provision "shell", inline: $SERVER_SETUP, privileged: true
    redis.vm.provision "file", source: "./vagrant.d/redis/redis.conf", destination: "~/redis.conf"
    redis.vm.provision "shell", inline: $CONFIGURE_REDIS
  end

end
