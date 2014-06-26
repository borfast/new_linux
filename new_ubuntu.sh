#!/bin/bash

## Assuming Linux Mint 17. Should also mostly work with Ubuntu 14.04

## Installing .deb packages could be done in a single go if I added the
## necessary repositories beforehand but this way the script is more
## modular and I can comment out any sections if I want to.

## TODO: install Prey, liquidprompt
## TODO: Rewrite this with Ansible?

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
sudo apt-get -y install bleachbit gimp inkscape sysv-rc-conf vim unace unrar p7zip-full curl synaptic python-software-properties openjdk-7-jre openjdk-7-jre-headless gparted compizconfig-settings-manager clamav-freshclam clamav vlc gstreamer0.10-plugins-bad-multiverse libavcodec-extra ubuntu-restricted-extras bash-completion

## Only for Ubuntu, Linux Mint doesn't need hacks to have a decent desktop environment.
#sudo apt-get install gnome-session-flashback

## If we want to make sure we get the very latest node and PHP stuff, add these PPAs.
sudo apt-add-repository -y ppa:chris-lea/node.js
#sudo apt-add-repository -y ppa:ondrej/php5

## Development shit
sudo apt-get -y install sublime-text build-essential python-setuptools python-dev apache2 nodejs php5 php5-cli php5-json php5-mysql php5-dev php5-curl php5-gd php5-mcrypt git git-flow gitg openjdk-7-jdk terminator meld mysql-client mysql-server ruby ruby-dev ruby2.0 ruby2.0-dev mysql-workbench
sudo a2enmod ssl rewrite
sudo php5enmod mcrypt
sudo service apache2 restart

## libdvdcss and latest VLC
sudo add-apt-repository -y ppa:videolan/stable-daily &&
sudo apt-get update
echo 'deb http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list &&
echo '# deb-src http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list &&
wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc|sudo apt-key add -
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

## Virtualenvwrapper and friends
sudo pip install virtualenvwrapper

## Ansible
sudo pip install ansible

## Git up
sudo gem install git-up

## Git flow completion
sudo wget https://raw.githubusercontent.com/bobthecow/git-flow-completion/master/git-flow-completion.bash -O /etc/bash_completion.d/git-flow-completion.bash

## Java
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer

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


## Clean up
echo "Cleaning Up" &&
sudo apt-get -f install &&
sudo apt-get autoremove &&
sudo apt-get -y autoclean &&
sudo apt-get -y clean
