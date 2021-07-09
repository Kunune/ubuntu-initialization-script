#!/bin/bash

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
# check os
#----------------------
curl -s https://raw.githubusercontent.com/zagabond/server-scripts/main/check-os.sh | bash

#--------------------
# update & upgrade
#--------------------
curl -s https://raw.githubusercontent.com/zagabond/server-scripts/main/update-upgrade.sh | bash

# ---------------------
# swap memory
# ---------------------
curl -s https://raw.githubusercontent.com/zagabond/server-scripts/main/swap-memory.sh | bash

#----------------------
# install text editor
#----------------------
curl -s https://raw.githubusercontent.com/zagabond/server-scripts/main/install-vim.sh | bash

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

echo -e "# m h dom mon dow command\n@reboot sudo iptables-restore < config/iptables.dump\n\n# 50 19 * * 7 sudo truncate -s 0 /var/log/nginx/access.log && sudo truncate -s 0 /var/log/nginx/error.log\n# 50 19 * * 7 sudo truncate -s 0 /var/log/fail2ban.log" | crontab

echo -e "# m h dom mon dow command\n@reboot sudo swapon /swapfile\n0 20 * * * sudo reboot\n0 19 * * * sudo apt update -y && sudo apt upgrade -y" | sudo crontab

#-------------------
# password reset
#-------------------

echo
echo -e "${BG_GREEN} Password reseted ${NC}"
sudo passwd -d "$USER"
echo -e "$ passwd"

#-------------------
# reboot
#-------------------
echo
echo -e "${BG_YELLOW} Restart automatically... ${NC}"

echo "It will restart in 5 seconds."
echo
echo -e "${RED}Password must be set after reboot.${NC}"
echo

sleep 5

sudo reboot
