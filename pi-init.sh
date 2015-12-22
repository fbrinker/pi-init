#!/usr/bin/env bash

BASEIP="192.168.178."

#
# Input
#
echo "#"
read -e -p "# The Name of the PI: " -i "" PI_NAME
echo "#"
echo "# Hello. From now on, my name is '$PI_NAME'"
echo "#"
read -e -p "My IP: " -i "$BASEIP" PI_IP
echo "#"
echo "# Okay. My IP will be '$PI_IP'"
echo "#"
read -e -p "# Ready to start the installation? " -i "y" PI_START

if [[ $PI_START != "y" ]]; then
    exit
fi

echo "#"
echo "# Here we go... :)"
echo "#"

#
# Updates
#
sudo apt-get update && sudo apt-get upgrade --yes
sudo apt-get install vim git

#
# Generate Key
#
cd ~
ssh-keygen -t rsa -b 4096 -C "pi@$PI_NAME"

echo "#"
echo "# Now, please add the following key to your Github profile, otherwise we can't continue... :)"
echo "#"
cat .ssh/id_rsa.pub
read PI_TMP

#
# Checkout && install my dotfiles
#
git clone https://github.com/fbrinker/dotfiles.git
~/dotfiles/install

#
# Change hostname
#
cp /etc/hostname /etc/hostname.bak
cp /etc/hosts /etc/hosts.bak

sudo sed -i -e 's/raspberrypi/$PI_NAME/g' /etc/hostname
sudo sed -i -e 's/raspberrypi/$PI_NAME/g' /etc/hosts
sudo /etc/init.d/hostname.sh

#
# Update ip config
#
cp /etc/dhcpcd.conf /etc/dhcpcd.conf.bak

declare -a PI_IP_ARRAY
PI_IP_ARRAY=(`echo ${PI_IP//./ }`)

echo "
#
# static config
#
interface eth0
    static ip_address=$PI_IP/24
    static routers=${IPARR[0]}.${IPARR[1]}.${IPARR[2]}.1
    static domain_name_servers=${IPARR[0]}.${IPARR[1]}.${IPARR[2]}.1" >> /etc/dhcpcd.conf
