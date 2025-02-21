#!/bin/bash

if [ -f "ubuntu.cfg.sh" ]; then source ubuntu.cfg.sh; fi

for Arg in "$@"
do
    case $Arg in
        base )
            BoolBase=true;;
        web )
            BoolBase=true;
            BoolNginx=true;
            BoolPhp=true;
            BoolNvm=true;
            BoolNFS=true;
            ;;
        *)
            echo "Error: $0 $Arg"
            exit;;
    esac
done

if [ "$BoolBase" = true ]; then
sudo apt update
sudo apt install net-tools -y
sudo timedatectl set-timezone Asia/Hong_Kong
sudo timedatectl set-ntp on
sudo apt install unzip
fi

if [ "$BoolVbox" = true ]; then
sudo apt install openssh-server -y
su root
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
fi

if [ "$BoolNginx" = true ]; then
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo add-apt-repository "deb http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -sc) nginx"
sudo apt-get update
sudo apt-get install nginx=1.27.*~$(lsb_release -sc)
nginx -v
sudo systemctl restart nginx
fi

if [ "$BoolPhp" = true ]; then
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php7.3 php7.3-{cli,common,curl,dev,zip,gd,imagick,imap,mbstring,mysql,opcache,redis,soap,xml,xmlrpc,mbstring,json,intl}
sudo apt install -y php7.4 php7.4-{cli,common,curl,dev,zip,gd,imagick,imap,mbstring,mysql,opcache,redis,soap,xml,xmlrpc,mbstring,json,intl}
sudo apt list --installed | grep php
sudo update-alternatives --config php
fi

if [ "$BoolNvm" = true ]; then
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install v20 --lts
nvm install v16 --lts
node -v
fi

if [ "$BoolNFS" = true ]; then
sudo apt update
sudo apt install nfs-common -y
sudo mkdir /mnt/efs
sudo chown ubuntu:ubuntu /mnt/efs
sudo chmod -R 775 /mnt/efs
fi