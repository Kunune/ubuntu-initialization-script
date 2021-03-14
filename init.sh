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
# check superuser
#----------------------

if [ "$EUID" != 0 ]; then
        echo "This script needs to be run with superuser privileges."
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

#----------------------
# clear screen
#----------------------
clear

#----------------------
# text editor
#----------------------

echo
echo -e "${BG_CYAN} Which text editor do you want to use? ${NC}"
echo "1) nano"
echo "2) vim"
echo "3) Do not install"

read -p "Enter a number [3] : " editor

until [[ -z "$editor" || "$editor" =~ ^[123] ]]; do
        echo -e "${BG_RED} $editor : invalid value ${NC}"
        read -p "Enter a number [3] : " editor
done
[ -z "$editor" ] && editor="3"

#---------------------
# firewall
#---------------------

echo
echo -e "${BG_CYAN} Which firewall do you want to use? ${NC}"
echo "1) firewalld"
echo "2) ufw"
echo "3) iptables (do not install)"

read -p "Enter a number [3] : " firewall

until [[ -z "$firewall" || "$firewall" =~ ^[123] ]]; do
        echo -e "${BG_RED} $firewall : invaild value ${NC}"
        read -p "Enter a number [3] : " firewall
done
[ -z "$firewall" ] && firewall="3"

#--------------------
# reverse proxy
#--------------------

echo
echo -e "${BG_CYAN} Do you want to install reverse proxy? ${NC}"
echo "1) Nginx"
echo "2) Apache2"
echo "3) Caddy"
echo "4) Do not install"

read -p "Enter a number [4] : " reverseProxy

until [[ -z "$reverseProxy" || "$reverseProxy" =~ ^[1234] ]]; do
        echo -e "${BG_RED} $reverseProxy : invalid value ${NC}"
        read -p "Enter a number [4] : " reverseProxy
done
[ -z "$reverseProxy" ] && reverseProxy="4"

#--------------------
# crontab
#--------------------
echo
echo -e "${BG_CYAN} Do you want to install crontab? ${NC}"

read -p "Give an answer (y/n) [n] : " cron

until [[ -z "$cron" || "$cron" =~ ^[yn] ]]; do
        echo -e "${BG_RED} $cron : invaild value ${NC}"
        read -p "Give an answer (y/n) [n] : " cron
done
[ -z "$cron" ] && cron="n"

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

apt update -y
echo

echo -e "${BG_GREEN} Upgrading... ${NC}"

apt upgrade -y
echo

#----------------------
# install text editor
#----------------------
echo
echo -e "${BG_GREEN} Installing text editor... ${NC}"
case $editor in
        1)
                apt install nano -y
                ;;
        2)
                apt install vim -y
                ;;
        3)
                echo -e "${YELLOW} Do not install. ${NC}"
                ;;
esac

#-----------------------
# install firewall
#-----------------------
echo
echo -e "${BG_GREEN} Installing firewall... ${NC}"
case $firewall in
        1)
                apt install firewalld -y
                ;;
        2)
                apt install ufw -y
                ;;
        3)
                echo -e "${YELLOW} Do not install. ${NC}"
                ;;
esac

#-----------------------
# install reverse proxy
#-----------------------

echo
echo -e "${BG_GREEN} Installing reverse proxy... ${NC}"
case $reverseProxy in
        1)
                apt install nginx -y
                ;;
        2)
                apt install apache2 -y
                ;;
        3)
                apt install -y debian-keyring debian-archive-keyring apt-transport-https
                curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo apt-key add -
                curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list
                apt update
                apt install caddy
                ;;
        4)
                echo -e "${YELLOW} Do not install. ${NC}"
                ;;
esac

#-------------------
# install crontab
#-------------------

echo
echo -e "${BG_GREEN} Installing crontab... ${NC}"
case $cron in
        y)
                apt install cron -y
                ;;
        n)
                echo -e "${YELLOW} Do not install. ${NC}"
                ;;
esac

#-------------------
# add alias
#-------------------

echo
echo -e "${BG_GREEN} Adding alias ${NC}"

alias sshd='cat /etc/ssh/sshd_config'
alias sshd-path='echo "/etc/ssh/sshd_config"'
alias sshd-restart='echo "sudo systemctl restart ssh"'

echo -e "${GREEN}sshd${NC} : view sshd_config"
echo -e "${GREEN}sshd-path${NC} : view sshd_config path"
echo -e "${GREEN}sshd-restart${NC} : show restart command"

#-------------------
# password reset
#-------------------

passwd -d "$USER"

echo
echo -e "${BG_GREEN} Password reseted ${NC}"
echo -e "${RED}Password must be set after reboot.${NC}"
echo -e "> passwd"

#-------------------
# reboot
#-------------------

echo
echo -e "${BG_YELLOW} Restart automatically... ${NC}"

echo "It will restart in 5 seconds."
echo
sleep 5

reboot
