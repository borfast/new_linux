#!/bin/bash

## Assuming Linux Mint 18. Should also mostly work with Ubuntu 16.04

## Installing .deb packages could be done in a single go if I added the
## necessary repositories beforehand but this way the script is more
## modular and I can comment out any sections if I want to.

## TODO: install Prey
## TODO: Rewrite this with Salt/Ansible?

## Let's detect the architecture
if [[ $(getconf LONG_BIT) = "64" ]]
then
    ARCH=64
else
    ARCH=32
fi

# Create the user bin folder and add it to the PATH
mkdir -p $HOME/progs/bin
echo "PATH DEFAULT=${PATH}:${HOME}/progs/bin" >> $HOME/.pam_environment
export PATH="$PATH:$HOME/progs/bin"

# Let's work in a temporary directory that is destroyed at the end of the script
mkdir $HOME/new_ubuntu_temp_and_a_random_string
pushd $HOME/new_ubuntu_temp_and_a_random_string


## Common software
sudo apt-add-repository -y ppa:inkscape.dev/stable
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install acpi gimp inkscape shutter libgoo-canvas-perl sysv-rc-conf vim unace unace-nonfree unrar p7zip-full curl whois synaptic python-software-properties openjdk-8-jre openjdk-8-jre-headless gparted compizconfig-settings-manager clamav-freshclam clamav chkrootkit rkhunter vlc gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad libavcodec-extra ubuntu-restricted-extras bash-completion ttf-mscorefonts-installer htop

## Add the official nodejs repository
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

## If we want to make sure we get the very latest PHP stuff, add this PPA.
sudo apt-add-repository -y ppa:ondrej/php

# Get the latest git.
sudo add-apt-repository ppa:git-core/ppa

## Development shit
sudo apt-get -y install build-essential python-setuptools python-dev python3-all-dev apache2 nodejs php php-pear php-cli php-json php-mysql php-pgsql php-sqlite3 php-dev php-mongodb php-xdebug php-curl php-gd php-mcrypt git git-flow gitg openjdk-8-jdk terminator meld mysql-client mysql-server postgresql postgresql-client postgresql-contrib pgadmin3 ruby ruby-dev mysql-workbench libsqlite3-dev libmysqlclient-dev libpq-dev redis-server redis-tools
sudo a2enmod ssl rewrite
sudo php7enmod mcrypt
sudo service apache2 restart

## libdvdcss and latest VLC
sudo add-apt-repository -y ppa:videolan/stable-daily &&
sudo apt-get update
echo 'deb http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list &&
echo '# deb-src http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list &&
curl http://download.videolan.org/pub/debian/videolan-apt.asc | sudo apt-key add -
sudo apt-get -y install libdvdcss2 vlc

## Install Google Chrome
if [ $ARCH == 64 ]
then
    CHROME_ARCH='amd64'
else
    CHROME_ARCH='i386'
fi
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_${CHROME_ARCH}.deb &&
sudo dpkg -i google-chrome-stable_current_${CHROME_ARCH}.deb &&
rm -f google-chrome-stable_current_${CHROME_ARCH}.deb


## Python pip
sudo easy_install pip

## Python PEP 8
sudo pip install -U pep8

## Virtualenvwrapper and friends
sudo pip install -U virtualenvwrapper
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc

## pyenv
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
echo "export PATH=\"/home/borfast/.pyenv/bin:\$PATH\"" >> .bashrc
echo "eval \"\$(pyenv init -)\"" >> .bashrc
echo "eval \"\$(pyenv virtualenv-init -)\"" >> .bashrc


## Fabric
sudo pip install -U fabric fexpect

## Git up
git config --global alias.up 'pull --rebase --autostash'

## Liquidprompt (https://github.com/nojhan/liquidprompt)
pushd $HOME
git clone https://github.com/nojhan/liquidprompt.git
echo "# Only load Liquid Prompt in interactive shells, not from a script or from scp" >> .bashrc
echo "[[ \$- = *i* ]] && source ~/liquidprompt/liquidprompt" >> .bashrc
popd

## MailHog - https://github.com/mailhog/MailHog/
curl -L -o $HOME/progs/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v0.1.8/MailHog_linux_amd64
chmod u+x $HOME/progs/bin/mailhog


## PHP Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=$HOME/progs
php -r "unlink('composer-setup.php');"
chmod +x $HOME/progs/composer.phar

## PHP CodeSniffer (phpcs) and Mess Detector (phpmd)
$HOME/progs/composer.phar global require "squizlabs/php_codesniffer=*"
$HOME/progs/composer.phar global require "phpmd/phpmd=*"

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
curl -o ./robomongo.tar.gz https://download.robomongo.org/1.0.0/linux/robomongo-1.0.0-linux-${ROBOMONGO_ARCH}-89f24ea.tar.gz &&
tar xfz robomongo.tar.gz &&
mv robomongo-1.0.0-linux-${ROBOMONGO_ARCH}-89f24ea $HOME/progs/
rm -rf ./robomongo-1.0.0-linux-${ROBOMONGO_ARCH}-89f24ea.tar.gz


## Clean up
echo "Cleaning Up" &&
popd &&
rm -rf $HOME/new_ubuntu_temp_and_a_random_string &&
sudo apt-get -f install &&
sudo apt-get autoremove &&
sudo apt-get -y autoclean &&
sudo apt-get -y clean