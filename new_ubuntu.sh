#!/bin/bash

## Assuming Ubuntu 14.04

## Let's detect the architecture
if [[ $(getconf LONG_BIT) = "64" ]]
then
	ARCH=64
else
	ARCH=32
fi

## Common software
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install sysv-rc-conf vim unace unrar p7zip-full curl synaptic python-setuptools python-software-properties openjdk-7-jre openjdk-7-jre-headless gparted compizconfig-settings-manager gnome-session-flashback clamav-freshclam clamav vlc gstreamer0.10-plugins-bad-multiverse libavcodec-extra ubuntu-restricted-extras

## Development shit
sudo apt-get -y install apache2 php5 php5-cli php5-json php5-mysql php5-dev php5-curl php5-gd php5-mcrypt git gitg openjdk-7-jdk terminator meld mysql-client mysql-server ruby ruby-dev ruby2.0 ruby2.0-dev mysql-workbench
sudo a2enmod ssl rewrite
sudo php5enmod mcrypt
sudo service apache2 restart

## libdvdcss (also updates VLC if a newer version is available)
sudo add-apt-repository -y ppa:videolan/stable-daily &&
sudo apt-get update &&
sudo apt-get -y install libdvdcss2 vlc

## Install Google Chrome
if [ $ARCH == 64 ]
then
	CHROME_ARCH='amd64'
else
	CHROME_ARCH='i386'
fi
wget https://dl.google.com/linux/direct/google-chrome-stable_current_${CHROME_ARCH}.deb &&
sudo dpkg -i google-chrome-stable_current_${CHROME_ARCH}.deb &&
rm -f google-chrome-stable_current_${CHROME_ARCH}.deb


# Python pip
sudo easy_install pip

## Ansible
sudo pip install ansible

## Git up
sudo gem install git-up

## Git flow
## TODO: shell completion
wget https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh &&
chmod +x ./gitflow-installer.sh &&
INSTALL_PREFIX=~/progs/bin ./gitflow-installer.sh &&
rm -rf ./gitflow-installer.sh

## RoboMongo
if [ $ARCH == 64 ]
then
	ROBOMONGO_ARCH='x86_64'
else
	ROBOMONGO_ARCH='i386'
fi
wget http://robomongo.org/files/linux/robomongo-0.8.4-${ROBOMONGO_ARCH}.deb &&
sudo dpkg -i ./robomongo-0.8.4-${ROBOMONGO_ARCH}.deb &&
rm -rf ./robomongo-0.8.4-${ROBOMONGO_ARCH}.deb


## TODO: install Sublime Text, Prey


## Clean up
echo "Cleaning Up" &&
sudo apt-get -f install &&
sudo apt-get autoremove &&
sudo apt-get -y autoclean &&
sudo apt-get -y clean