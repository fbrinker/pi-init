# pi-init
This is my init script for [debian based rapsberrypi images](https://www.raspberrypi.org/downloads) (I prefer the raspbian LITE one without any desktop).

![preview](http://i.imgur.com/MiPD6SA.png)

# Features
I'm testing out a lot of home automation stuff at the moment and prototype some ideas. So i have to install different debian based sd card images from time to time. This script does all the first magic.
* Setting a hostname (name of the pi)
* Setting a static ip
* Creating a ssh key (for example for github)
* Installing [my dotfiles](https://github.com/fbrinker/dotfiles) (you can use them too :)
* Installing an authorized ssh key for easier logins (leave empty if not needed)
* Sums up all made changes
Afterwards you have to reboot manually.

# Usage
To install & run the init script, execute the following commands
```
curl -LSso ~/pi-init.sh https://raw.githubusercontent.com/fbrinker/pi-init/master/pi-init.sh
chmod +x ~/pi-init.sh
./pi-init.sh
```

# Troubleshooting
Sometimes, after changing the hostname and setting the ip address, if have problems connecting to the "new" raspberrypi. Then i have to delete the device from my AVM Fritzbox router, restart it and the network (router) recognises it correctly.
