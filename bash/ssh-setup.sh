#/bin/bash
filename=sshd_config

apt-get install wget openssh-server -y

wget -q -c https://raw.githubusercontent.com/mweatherilt/public/main/conf/sshd.conf -O /etc/ssh/ssh_config.d/sysctl.conf

