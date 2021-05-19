# Envirionment

- Ubuntu 20.04 LTS Focal Fossa | ✅ 3/4/21

# Usage

    curl https://raw.githubusercontent.com/zagabond/ubuntu-initialization-script/main/init.sh | bash

# Functions

**Text editor** : vim

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

**Firewall** : iptables

    @reboot sudo iptables-restore < config/iptables.dump

**crontab**

`user crontab`

    # m h dom mon dow command
    @reboot sudo iptables-restore < config/iptables.dump

    # 50 19 * * 7 sudo truncate -s 0 /var/log/nginx/access.log
    # 50 19 * * 7 sudo truncate -s 0 /var/log/nginx/error.log
    # 50 19 * * 7 sudo truncate -s 0 /var/log/fail2ban.log
    
`root crontab`

    # m h dom mon dow command
    @reboot sudo swapon /swapfile
    0 20 * * * sudo reboot
    0 19 * * * sudo apt update -y && sudo apt upgrade -y

**swap**

    sudo fallocate -l 1GB /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    
**password reset**

    sudo passwd -d "$USER"
