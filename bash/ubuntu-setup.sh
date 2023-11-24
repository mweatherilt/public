#/bin/bash

# This script is fork from Conduro Ubuntu 20.04 https://github.com/conduro

# color codes
RESTORE='\033[0m'
BLACK='\033[00;30m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
LBLACK='\033[01;30m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'
OVERWRITE='\e[1A\e[K'

logfile='setup.log'

function _task {
    # if _task is called while a task was set, complete the previous
    if [[ $TASK != "" ]]; then
        printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"
    fi
    # set new task title and print
    TASK=$1
    printf "${LBLACK} [ ]  ${TASK} \n${LRED}"
}

# _cmd performs commands with error checking
function _cmd {
    > $logfile
    # hide stdout, on error we print and exit
    if eval "$1" 1> /dev/null 2> $logfile; then
        return 0 # success
    fi
    # read error from log and add spacing
    printf "${OVERWRITE}${LRED} [X]  ${TASK}${LRED}\n"
    while read line; do 
        printf "      ${line}\n"
    done < $logfile
    printf "\n"
    # remove log file
    rm $logfile
    # exit installation
    exit 1
} 

# Must run as root
if [[ $(id -u) -ne 0 ]] ; then printf "\n${LRED} Please run as root${RESTORE}\n\n" ; exit 1 ; fi

# dependencies
_task "update dependencies"
    _cmd 'apt-get install wget sed git -y'

# finish last task
printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"

# update system
_task "update system"
    _cmd 'apt-get update -y && apt-get full-upgrade -y'

# finish last task
printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"

# description update nameservers
printf "      ${YELLOW}Do you want to update nameservers? [Y/n]: ${RESTORE}"
read prompt && printf "${OVERWRITE}" && if [[ $prompt == "y" || $prompt == "Y" ]]; then
	_task "update nameservers"
	    _cmd 'truncate -s0 /etc/resolv.conf'
	    _cmd 'echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf'
	    _cmd 'echo "nameserver 1.0.0.1" | sudo tee -a /etc/resolv.conf'
fi

# description update time server
printf "      ${YELLOW}Do you want to update ntp servers? [Y/n]: ${RESTORE}"
read prompt && printf "${OVERWRITE}" && if [[ $prompt == "y" || $prompt == "Y" ]]; then
	_task "update ntp servers"
	    _cmd 'truncate -s0 /etc/systemd/timesyncd.conf'
	    _cmd 'echo "[Time]" | sudo tee -a /etc/systemd/timesyncd.conf'
	    _cmd 'echo "NTP=time.cloudflare.com" | sudo tee -a /etc/systemd/timesyncd.conf'
	    _cmd 'echo "FallbackNTP=ntp.ubuntu.com" | sudo tee -a /etc/systemd/timesyncd.conf'
fi

# description update sysctl
printf "      ${YELLOW}Do you want to update sysctl? [Y/n]: ${RESTORE}"
read prompt && printf "${OVERWRITE}" && if [[ $prompt == "y" || $prompt == "Y" ]]; then
	_task "update sysctl.conf"
	    _cmd 'mv /etc/sysctl.conf /etc/sysctl.old'
	    _cmd 'wget --timeout=5 --tries=2 --quiet -c https://raw.githubusercontent.com/mweatherilt/public/main/conf/sysctl.conf -O /etc/sysctl.conf'
fi

# description harden openssh
printf "      ${YELLOW}Do you want to harden ssh? [Y/n]: ${RESTORE}"
read prompt && printf "${OVERWRITE}" && if [[ $prompt == "y" || $prompt == "Y" ]]; then
	_task "update sshd_config"
	    _cmd 'wget --timeout=5 --tries=2 --quiet -c https://raw.githubusercontent.com/mweatherilt/public/main/conf/sshd_config.conf -O /etc/ssh/ssh_config.d/sshd_config.conf'
	    _cmd 'wget --timeout=5 --tries=2 --quiet -c https://raw.githubusercontent.com/mweatherilt/public/main/keys/sshkey.pub -O ~/sshkey.pub'

fi

# description disable system logging
printf "      ${YELLOW}Do you want to disable system logging? [Y/n]: ${RESTORE}"
read prompt && printf "${OVERWRITE}" && if [[ $prompt == "y" || $prompt == "Y" ]]; then
	_task "disable system logging"
	    _cmd 'systemctl stop systemd-journald.service'
	    _cmd 'systemctl disable systemd-journald.service'
	    _cmd 'systemctl mask systemd-journald.service'

	    _cmd 'systemctl stop rsyslog.service'
	    _cmd 'systemctl disable rsyslog.service'
	    _cmd 'systemctl mask rsyslog.service'
fi

# firewall
printf "      ${YELLOW}Do you want to set firewall? [Y/n]: ${RESTORE}"
read prompt && printf "${OVERWRITE}" && if [[ $prompt == "y" || $prompt == "Y" ]]; then
	_task "configure firewall"
	    _cmd 'ufw disable'
	    _cmd 'echo "y" | sudo ufw reset'
	    _cmd 'ufw logging off'
	    _cmd 'ufw default deny incoming'
	    _cmd 'ufw default allow outgoing'
#	    _cmd 'ufw allow 80/tcp comment "http"'
#	    _cmd 'ufw allow 443/tcp comment "https"'
	    printf "${YELLOW} [?]  specify ssh port [leave empty for 22]: ${RESTORE}"
	    read prompt && printf "${OVERWRITE}" && if [[ $prompt != "" ]]; then
	        _cmd 'ufw allow ${prompt}/tcp comment "ssh"'
	        _cmd 'echo "Port ${prompt}" | sudo tee -a /etc/ssh/sshd_config'
	    else 
	        _cmd 'ufw allow 22/tcp comment "ssh"'
	    fi
	    _cmd 'sed -i "/ipv6=/Id" /etc/default/ufw'
	    _cmd 'echo "IPV6=no" | sudo tee -a /etc/default/ufw'
	    _cmd 'sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/Id" /etc/default/grub'
	    _cmd 'echo "GRUB_CMDLINE_LINUX_DEFAULT=\"ipv6.disable=1 quiet splash\"" | sudo tee -a /etc/default/grub'
fi

# description
#_task "free disk space"
#    _cmd 'find /var/log -type f -delete'
#    _cmd 'rm -rf /usr/share/man/*'
#    _cmd 'apt-get autoremove -y'
#    _cmd 'apt-get autoclean -y'
    # _cmd "purge" 'apt-get remove --purge -y'
    # _cmd "clean" 'apt-get clean && sudo apt-get --purge autoremove -y'

# description
#_task "reload system"
#    _cmd 'sysctl -p'
#    _cmd 'update-grub2'
#    _cmd 'systemctl restart systemd-timesyncd'
#    _cmd 'ufw --force enable'
#    _cmd 'service ssh restart'

# finish last task
printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"

# remove file file
rm $logfile

# reboot
printf "\n${YELLOW} Do you want to reboot [Y/n]? ${RESTORE}"
read prompt && printf "${OVERWRITE}" && if [[ $prompt == "y" || $prompt == "Y" ]]; then
    reboot
fi

# exit
exit 1
