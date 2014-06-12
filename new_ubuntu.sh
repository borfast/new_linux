#!/bin/bash

## Assuming Ubuntu 14.04

## Common software
sudo apt-get update
sudo apt-get install sysv-rc-conf vim unace unrar p7zip-full curl synaptic python-setuptools python-software-properties openjdk-7-jre openjdk-7-jre-headless gparted compizconfig-settings-manager gnome-session-flashback clamav-freshclam clamav vlc gstreamer0.10-plugins-bad-multiverse libavcodec-extra

## Development shit
sudo apt-get install apache2 php5 php5-cli php5-json php5-mysql php5-dev php5-curl php5-gd php5-mcrypt git gitg openjdk-7-jdk terminator meld mysql-client mysql-server ruby ruby-dev ruby2.0 ruby2.0-dev mysql-workbench

## libdvdcss (also updates VLC if a newer version is available)
wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc|sudo apt-key add -
sudo sh -c "echo 'deb http://download.videolan.org/pub/debian/stable/ /' > /etc/apt/sources.list.d/videolan.list"
sudo apt-get install libdvdcss2 vlc

# Python pip
sudo easy_install pip

## Ansible
sudo pip install ansible

## Git up
sudo gem install git-up

## Git flow
## TODO: shell completion
wget https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh
chmod +x ./gitflow-installer.sh
INSTALL_PREFIX=~/progs/bin ./gitflow-installer.sh
rm -rf ./gitflow-installer.sh

## RoboMongo
wget http://robomongo.org/files/linux/robomongo-0.8.4-i386.deb
sudo dpkg -i ./robomongo-0.8.4-i386.deb
rm -rf ./robomongo-0.8.4-i386.deb

## TODO: install Google Chrome, Sublime Text, Prey