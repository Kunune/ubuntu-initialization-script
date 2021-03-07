#!/bin/bash

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
# check OS
#----------------------

os=`cat /etc/os-release | grep ubuntu`
[ -z "$os" ] && echo -e "${BG_RED} It can only run on Ubuntu. ${NC}"

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


if [ "$firewall" != 3 ]; then
        echo
        echo -e "${BG_CYAN} Which port do you want to disable firewall? ${NC}"
        echo -e "${RED}The entered ports are disabled by TCP and are accessible from any IP.  ${NC}"
        read -p "Enter a port [exit] : " a

        index=0

        until [[ -z "$a" ]]; do
                echo
                port[$index]=$a
                echo -e "${BG_YELLOW} Currently entered ${NC}"
                for item in "${port[@]}"; do
                        printf "$item "
                done
                echo
                ((index=index+1))
                read -p "Enter a port [exit] : " a
        done
fi

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
echo -e "${BG_GREEN} Updating apt... ${NC}"

apt update -y
echo

echo -e "${BG_GREEN} Upgrading apt... ${NC}"

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

echo
echo -e "${BG_GREEN} Setting Firewall... ${NC}"
case $firewall in
        1)
                for item in "${port[@]}"; do
                        firewall-cmd --permanent --zone="public" --add-port="${item}/tcp"
                done
                firewall-cmd --reload
                ;;
        2)
                for item in "${port[@]}"; do
                        ufw allow ${item}
                done
                ufw enable
                ;;
        3)
                echo -e "${RED} You must disable the firewall with iptables. ${NC}"
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
# reboot
#-------------------

echo
echo -e "${BG_YELLOW} Restart automatically... ${NC}"
sleep 5
reboot
