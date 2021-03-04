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

BG_RED="\e[1;41m"
BG_GREEN="\e[1;42m"
NC="\e[0m"

#----------------------
# check OS
#----------------------

os=`cat /etc/os-release | grep ubuntu`
[ -z "$os" ] && echo -e "${BG_RED} It can only run on Ubuntu. ${NC}"

#----------------------
# text editor
#----------------------

echo
echo "Which editor do you want to use?"
echo "1) vim"
echo "2) nano"
echo "3) I don't want to install it"

read -p "enter a number [1] : " editor

until [[ -z "$editor" || "$editor" =~ ^[123] ]]; do
        echo -e "${BG_RED} $editor : invalid value ${NC}"
        read -p "enter a number [1] : " editor
done
[ -z "$editor" ] && editor="1"

#---------------------
# firewall
#---------------------

echo
echo "Which firewall do you want to use?"
echo "1) firewalld"
echo "2) ufw"
echo "3) iptables"

read -p "enter a number [1] : " firewall

until [[ -z "$firewall" || "$firewall" =~ ^[123] ]]; do
        echo -e "${BG_RED} $firewall : invaild value ${NC}"
        read -e "enter a number [1] : " firewall
done
[ -z "$firewall" ] && firewall="1"

#--------------------
# crontab
#--------------------
echo
read -p "Do you want to install crontab? (y/n) [n] : " cron

until [[ -z "$cron" || "$cron" =~ ^[yn] ]]; do
        echo -e "${BG_RED} $cron : invaild value ${NC}"
        read -p "Do you want to install crontab? (y/n) [n] : " cron
done
[ -z "$cron" ] && cron="n"

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
                e=`apt list | grep vim`
                [ -n "$e" ] && echo -e "vim is already installed"
                [ -z "$e" ] && apt install vim -y
                ;;
        2)
                e=`apt list | grep nano`
                [ -n "$e" ] && echo -e "nano is already installed"
                [ -z "$e" ] && apt install nano -y
                ;;
        3)
                echo -e "You do not want to install text editor."
                ;;
esac

#-----------------------
# install firewall
#-----------------------
echo
echo -e "${BG_GREEN} Installing firewall... ${NC}"
case $firewall in
        1)
                e=`apt list | grep firewalld`
                [ -n "$e" ] && echo -e "firewalld is already installed"
                [ -z "$e" ] && apt install firewalld -y
                ;;
        2)
                e=`apt list | grep ufw`
                [ -n "$e" ] && echo -e "ufw is already installed"
                [ -z "$e" ] && apt install ufw -y
                ;;
        3)
                echo -e "Firewall must be set to iptables"
                ;;
esac

#-------------------
# install crontab
#-------------------

echo
echo -e "${BG_GREEN} Installing crontab... ${NC}"
case $cron in
        y)
                e=`apt list | grep cron`
                [ -n "$cron" ] && echo -e "firewalld is already installed"
                [ -z "$cron" ] && apt install cron -y
                ;;
        n)
                echo -e "You do not want to install crontab"
                ;;
esac
