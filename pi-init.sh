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
read -e -p "# My IP: " -i "$BASEIP" PI_IP
echo "#"
echo "# Okay. My IP will be '$PI_IP'"
echo "#"
read -e -p "# Ready to start the installation? " -i "y" PI_START

if [[ $PI_START != "y" ]]; then
    exit
fi

#
# Updates
#
echo "#"
echo "# Here we go... Installing updates and basic software packages... :)"
echo "#"
sudo apt-get update && sudo apt-get upgrade --yes
sudo apt-get install vim git

#
# Generate Key
#
echo "#"
echo "# Creating ssh key..."
echo "#"
cd ~
ssh-keygen -t rsa -b 4096 -C "pi@$PI_NAME"

echo "#"
echo "# Now, please add the following key to your Github profile, otherwise we can't continue... :)"
echo "# https://github.com/settings/ssh"
echo "# ----------"
cat .ssh/id_rsa.pub
echo "# ----------"
echo "# Press [ENTER] when you're done."
echo "#"
read PI_TMP

#
# Insert Key Auth
#
echo "#"
echo "# Adding an AUTH key..."
echo "#"
read -e -p "# You may want to add a ssh key to the authorized hosts now: " -i "" PI_AUTHKEY
touch ~/.ssh/authorized_keys
echo $PI_AUTHKEY >> ~/.ssh/authorized_keys

#
# Checkout && install my dotfiles
#
echo "#"
echo "# Checking out the dotfiles..."
echo "#"
git clone git@github.com:fbrinker/dotfiles.git
~/dotfiles/install

#
# Change hostname
#
echo "#"
echo "# Changing the hostname..."
echo "#"
sudo cp /etc/hostname /etc/hostname.bak
sudo cp /etc/hosts /etc/hosts.bak

sudo sed -i -e "s/raspberrypi/$PI_NAME/g" /etc/hostname
sudo sed -i -e "s/raspberrypi/$PI_NAME/g" /etc/hosts
sudo /etc/init.d/hostname.sh

#
# Update ip config
#
echo "#"
echo "# Changing the ip..."
echo "#"
sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.bak

declare -a PI_IP_ARRAY
PI_IP_ARRAY=(`echo ${PI_IP//./ }`)

sudo echo "
#
# static config
#
interface eth0
    static ip_address=$PI_IP/24
    static routers=${PI_IP_ARRAY[0]}.${PI_IP_ARRAY[1]}.${PI_IP_ARRAY[2]}.1
    static domain_name_servers=${PI_IP_ARRAY[0]}.${PI_IP_ARRAY[1]}.${PI_IP_ARRAY[2]}.1" >> /etc/dhcpcd.conf

#
# Done
#
echo "#"
echo "# Wow, we are done now."
echo "# You may want to check the following files for a correct configuration:"
echo "# /etc/hostname:"
echo "# ----------"
sudo cat /etc/hostname
echo "# ----------"
echo "#"
read PI_TMP
echo "# /etc/hosts:"
echo "# ----------"
sudo cat /etc/hosts
echo "# ----------"
echo "#"
read PI_TMP
echo "# /etc/dhcpcd.conf:"
echo "# ----------"
sudo cat /etc/dhcpcd.con
echo "# ----------"
echo "#"
read PI_TMP

echo "#"
echo "# Now, if everything is correct, please reboot the device."
echo "# sudo reboot"
echo "#"
echo "# Thanks. Bye :)"
echo "#"
