#!/usr/bin/env bash

set -e

sudo curl -sL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x93C4A3FD7BB9C367" | sudo apt-key add
sudo apt-get update
sudo apt-get install python-pip docker docker-compose -y
sudo pip install docker docker-compose

sudo apt-get install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y
sudo apt-get clean

cd /
sudo git clone https://github.com/devopsloft/devopsloft.git /vagrant
source /vagrant/.env

WEB_GUEST_PORT=80
WEB_HOST_PORT=80
WEB_GUEST_SECURE_PORT=443
WEB_HOST_SECURE_PORT=443
ENVIRONMENT=stage

sudo sed -i 's/3.7/3.3/g' $BASE_FOLDER/docker-compose.yml
cd $BASE_FOLDER
sudo openssl req -x509 -newkey rsa:4096 -nodes -out web_s2i/cert.pem -keyout web_s2i/key.pem -days 365 -subj "/C=IL/ST=Gush-Dan/L=Tel-Aviv/O=DevOps Loft/OU=''/CN=''"
sudo scripts/docker-compose-provision.sh $ENVIRONMENT $BASE_FOLDER $WEB_HOST_PORT $WEB_GUEST_PORT $WEB_HOST_SECURE_PORT $WEB_GUEST_SECURE_PORT
#sudo scripts/vault-init.sh .
sudo docker-compose -f docker-compose.yml down

