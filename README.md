# pi-init
This is my init script for [debian based rapsberrypi images](https://www.raspberrypi.org/downloads) (I prefer the raspbian LITE one without any desktop). But you should be able to use it with any debian jessie+ machine. I didn't test it in other environments.

![preview](http://i.imgur.com/MiPD6SA.png)

# Features
I'm testing out a lot of home automation stuff at the moment and prototype some ideas. So i have to install different debian based SD card images from time to time. This script does all the first magic.
* Setting a hostname (name of the pi in /etc/hosts and /etc/hostname)
* Setting a static eth0 and wlan0 ip (via dhcpcd.conf)
* Configuring your wifi network settings
* Creating a ssh key (for example for github)
* Installing [my very basic dotfiles](https://github.com/fbrinker/dotfiles) (feel free to use them too :)
* Installing an authorized ssh key for easier logins (leave empty if not needed)
* Sums up all changes made

Afterwards you have to reboot manually.

# Usage
To install & run the init script, execute the following commands
```
curl -LSso ~/pi-init.sh https://raw.githubusercontent.com/fbrinker/pi-init/master/pi-init.sh
chmod +x ~/pi-init.sh
./pi-init.sh
```
And then reboot the machine and you're done.

# Troubleshooting
##### I can't connect to the rebooted pi
* Sometimes, after changing the hostname and setting the ip address, I have problems connecting (or even pinging) to the "new" raspberrypi... I have to delete the device from my AVM Fritzbox routers dhcp configuration, restart the pi and the network (router) will recognise the pi correctly.
