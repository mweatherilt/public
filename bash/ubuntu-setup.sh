#/bin/bash

# This script is fork from Conduro Ubuntu 20.04 https://github.com/conduro
# This script is to setup a new host for ansible

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
    _cmd 'apt-get install wget -y'

# finish last task
printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"

# update system
_task "update system"
    _cmd 'apt-get update -y && apt-get full-upgrade -y'

# finish last task
printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"

# description setup openssh for ansible
_task "update sshd_config"
    _cmd 'wget --timeout=5 --tries=2 --quiet -c https://raw.githubusercontent.com/mweatherilt/public/main/conf/ssh_config.conf -O /etc/ssh/ssh_config.d/ssh_config.conf'
    _cmd 'wget --timeout=5 --tries=2 --quiet -c https://raw.githubusercontent.com/mweatherilt/public/main/keys/sshkey.pub -O ~/sshkey.pub'
    _cmd 'wget --timeout=5 --tries=2 --quiet -c https://raw.githubusercontent.com/mweatherilt/public/main/keys/ansible.pub -O ~/sshkey.pub'

# finish last task
printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"

# remove file file
rm $logfile

# exit
exit 1
