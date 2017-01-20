#!/usr/bin/env bash

sudo -v
# prompt the user for root creds
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set locale to en_US.UTF-8
cp /etc/locale.gen /etc/locale.gen.dist
sed -i -e "/^[^#]/s/^/#/" -e "/en_US.UTF-8/s/^#//" /etc/locale.gen

cp /var/cache/debconf/config.dat /var/cache/debconf/config.dat.dist
sed -i -e "/^Value: en_GB.UTF-8/s/en_GB/en_US/" \
       -e "/^ locales = en_GB.UTF-8/s/en_GB/en_US/" /var/cache/debconf/config.dat
locale-gen
update-locale LANG=en_US.UTF-8

# At this point, either log out and log in again, or reboot.
# Rebooting seems easier if this is really being run from fabric.
# If you do any upgrades, you may have to run the locale commands again

# Set timezone to America/Los_Angeles
cp /etc/timezone /etc/timezone.dist
echo "America/Los_Angeles" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Set the keyboard to US, don't set any modifier keys, etc.
cp /etc/default/keyboard /etc/default/keyboard.dist
sed -i -e "/XKBLAYOUT=/s/gb/us/" /etc/default/keyboard
service keyboard-setup restart

apt-get update
apt-get upgrade -y