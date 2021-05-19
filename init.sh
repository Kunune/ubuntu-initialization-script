#!/bin/bash

#----------------------
# check os
#----------------------
if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
fi

if [ "$OS" != "Ubuntu" ]; then
        echo "This script seems to be running on an unsupported distribution."
        echo "Supported distribution is Ubuntu."
        exit
fi

#----------------------
# text color
#----------------------
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BG_RED="\e[1;41m"
BG_GREEN="\e[1;42m"
BG_YELLOW="\e[1;43m"
BG_MAGENTA="\e[1;45m"
BG_CYAN="\e[1;46m"
NC="\e[0m"

#-------------------
# before start
#-------------------
echo
echo -e "${BG_GREEN} Setup is ready to install. ${NC}"
read -n1 -r -p "Press any key to continue..."

#--------------------
# start
#--------------------
echo
echo -e "${BG_GREEN} Updating... ${NC}"

sudo apt update -y

echo
echo -e "${BG_GREEN} Upgrading... ${NC}"

sudo apt upgrade -y

# ---------------------
# swap memory
# ---------------------
echo
echo -e "${BG_GREEN} Setting swap memory... ${NC}"
sudo fallocate -l 1GB /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#----------------------
# install text editor
#----------------------
echo
echo -e "${BG_GREEN} Installing text editor... ${NC}"
sudo apt install vim -y

cat << EOF > /home/ubuntu/.vimrc
syntax on
set paste
set number
set autoindent
set smartindent
set cindent
set ruler
set softtabstop=4
set shiftwidth=4
set tabstop=4
set hlsearch
set showmatch
set wmnu
set cursorline
EOF

sudo cp .vimrc /root

#-----------------------
# install firewall
#-----------------------
echo
echo -e "${BG_GREEN} Installing firewall... ${NC}"
sudo apt install iptables -y

mkdir config
sudo iptables-save > config/iptables.dump

#-------------------
# install crontab
#-------------------
echo
echo -e "${BG_GREEN} Installing crontab... ${NC}"
sudo apt install cron -y

echo -e "# m h dom mon dow command\n@reboot sudo iptables-restore < config/iptables.dump\n\n# 50 19 * * 7 sudo truncate -s 0 /var/log/nginx/access.log\n# 50 19 * * 7 sudo truncate -s 0 /var/log/nginx/error.log\n# 50 19 * * 7 sudo truncate -s 0 /var/log/fail2ban.log" | crontab

echo -e "# m h dom mon dow command\n@reboot sudo swapon /swapfile\n0 20 * * * sudo reboot\n0 19 * * * sudo apt update -y && sudo apt upgrade -y" | sudo crontab

#-------------------
# password reset
#-------------------

echo
echo -e "${BG_GREEN} Password reseted ${NC}"
sudo passwd -d "$USER"
echo -e "${RED}Password must be set after reboot.${NC}"
echo -e "$ passwd"

#-------------------
# reboot
#-------------------
echo
echo -e "${BG_YELLOW} Restart automatically... ${NC}"

echo "It will restart in 5 seconds."
echo

sleep 5

sudo reboot
