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

#----------------------
# clear screen
#----------------------
clear

#----------------------
# text editor
#----------------------
echo
echo -e "${BG_CYAN} Text editor ${NC}"
echo "1) nano"
echo "2) Do not install"

read -p "Text editor [1] : " editor

until [[ -z "$editor" || "$editor" =~ ^[12] ]]; do
        echo -e "${BG_RED} $editor : invalid value ${NC}"
        read -p "Text editor [1] : " editor
done
[ -z "$editor" ] && editor="1"

#---------------------
# firewall
#---------------------
echo
echo -e "${BG_CYAN} Firewall ${NC}"
echo "1) iptables"
echo "2) Do not install"

read -p "Firewall [1] : " firewall

until [[ -z "$firewall" || "$firewall" =~ ^[12] ]]; do
        echo -e "${BG_RED} $firewall : invaild value ${NC}"
        read -p "Firewall [1] : " firewall
done
[ -z "$firewall" ] && firewall="1"

#--------------------
# reverse proxy
#--------------------
echo
echo -e "${BG_CYAN} Reverse proxy ${NC}"
echo "1) Nginx"
echo "2) Do not install"

read -p "Reverse proxy [2] : " reverseProxy

until [[ -z "$reverseProxy" || "$reverseProxy" =~ ^[12] ]]; do
        echo -e "${BG_RED} $reverseProxy : invalid value ${NC}"
        read -p "Reverse proxy [2] : " reverseProxy
done
[ -z "$reverseProxy" ] && reverseProxy="2"

#--------------------
# crontab
#--------------------
echo
echo -e "${BG_CYAN} Crontab ${NC}"

read -p "install (y/n) [y] : " cron

until [[ -z "$cron" || "$cron" =~ ^[yn] ]]; do
        echo -e "${BG_RED} $cron : invaild value ${NC}"
        read -p "install (y/n) [y] : " cron
done
[ -z "$cron" ] && cron="y"

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

#----------------------
# install text editor
#----------------------
echo
echo -e "${BG_GREEN} Installing text editor... ${NC}"
case $editor in
        1)
                sudo apt install nano -y
                ;;
        2)
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
            sudo apt install iptables -y
            ;;
        2)
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
            sudo apt install nginx -y
            ;;
        2)
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
            sudo apt install cron -y
            ;;
        n)
            echo -e "${YELLOW} Do not install. ${NC}"
            ;;
esac

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

sudo reboot
