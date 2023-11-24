#/bin/bash

apt-get install docker.io -y

username=matt

adduser $username

sudo usermod -aG docker $username