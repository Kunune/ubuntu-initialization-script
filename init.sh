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

#----------------------
# initialize firewall
#----------------------
curl -s https://raw.githubusercontent.com/zagabond/server-scripts/main/init-ipconfig.sh | bash

#-------------------
# install crontab
#-------------------
echo
echo -e "${BG_GREEN} Installing crontab... ${NC}"
sudo apt install cron -y

echo -e "# m h dom mon dow command\n@reboot sudo iptables-restore < config/iptables.dump\n\n# 50 19 * * 7 sudo truncate -s 0 /var/log/nginx/access.log && sudo truncate -s 0 /var/log/nginx/error.log\n# 50 19 * * 7 sudo truncate -s 0 /var/log/fail2ban.log" | crontab

echo -e "# m h dom mon dow command\n@reboot sudo swapon /swapfile\n0 20 * * * sudo reboot\n0 19 * * * sudo apt update -y && sudo apt upgrade -y" | sudo crontab

#-------------------------
# reset password & reboot
#-------------------------
curl -s https://raw.githubusercontent.com/zagabond/server-scripts/main/reset-password.sh | bash
curl -s https://raw.githubusercontent.com/zagabond/server-scripts/main/reboot-after-setup.sh | bash
