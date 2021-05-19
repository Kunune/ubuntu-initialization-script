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

    # m h  dom mon dow   command
    @reboot sudo iptables-restore < config/iptables.dump
    
`root crontab`

    # m h dom mon dow command
    @reboot sudo iptables-restore < config/iptables.dump

    # 50 19 * * 7 sudo truncate -s 0 /var/log/nginx/access.log
    # 50 19 * * 7 sudo truncate -s 0 /var/log/nginx/error.log
    # 50 19 * * 7 sudo truncate -s 0 /var/log/fail2ban.log
