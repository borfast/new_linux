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


###################
# Common software #
###################
sudo apt-add-repository -y ppa:inkscape.dev/stable
sudo apt update
sudo apt -y upgrade
sudo apt -y install acpi gimp inkscape shutter libgoo-canvas-perl sysv-rc-conf vim unace unace-nonfree unrar p7zip-full curl wget whois synaptic python-software-properties openjdk-8-jre openjdk-8-jre-headless gparted compizconfig-settings-manager clamav-freshclam clamav chkrootkit rkhunter vlc gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad libavcodec-extra ubuntu-restricted-extras bash-completion ttf-mscorefonts-installer htop apt-transport-https

############################
# libdvdcss and latest VLC #
############################
sudo add-apt-repository -y ppa:videolan/stable-daily
curl http://download.videolan.org/pub/debian/videolan-apt.asc | sudo apt-key add -
sudo apt update
sudo apt -y install libdvd-pkg vlc
sudo dpkg-reconfigure libdvd-pkg


#################
# Google Chrome #
#################
if [ $ARCH == 64 ]
then
    CHROME_ARCH='amd64'
else
    CHROME_ARCH='i386'
fi
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_${CHROME_ARCH}.deb &&
sudo dpkg -i google-chrome-stable_current_${CHROME_ARCH}.deb &&
rm -f google-chrome-stable_current_${CHROME_ARCH}.deb


####################
# Development shit #
####################
sudo apt -y install make build-essential git gitg git-cola openjdk-8-jdk terminator meld mysql-client postgresql-client postgresql-contrib pgadmin3 ruby ruby-dev mysql-workbench libsqlite3-dev libmysqlclient-dev libpq-dev redis-tools


#######
# Git #
#######
sudo add-apt-repository ppa:git-core/ppa
sudo apt install git
git config --global alias.up 'pull --rebase --autostash'
git config --global user.signingkey #######
git config --global gpg.program /usr/bin/gpg2
git config --global commit.gpgSign true



##########
# Python #
##########
sudo apt install python-pip python-setuptools python-wheel python-all-dev python3-pip python3-setuptools python3-wheel python3-all-dev
pip3 install --user -U pipenv

sudo apt install -y libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev  llvm libncurses5-dev libncursesw5-dev xz-utils
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
cat >> .bashrc << EOF

export PATH="/home/borfast/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOF


########
# Node #
########
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install nodejs 


########
# Java #
########
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt update
sudo apt -y install oracle-java8-installer


#################################################
# MailHog - https://github.com/mailhog/MailHog/ #
#################################################
curl -L -o $HOME/progs/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
chmod u+x $HOME/progs/bin/mailhog


###########################
# Studio 3T (for Mongodb) #
###########################
if [ $ARCH == 64 ]
then
    MONGO_ARCH='x64'
else
    MONGO_ARCH='x86'
fi
curl -o ./studio3t.tar.gz https://download.studio3t.com/studio-3t/linux/5.5.0/studio-3t-linux-${MONGO_ARCH}.tar.gz &&
tar -C $HOME/progs/ -xfz studio3t.tar.gz
rm -rf ./studio3t.tar.gz



#########
# MySQL #
#########
# sudo apt install mysql-server

##############
# PostgreSQL #
##############
# sudo apt install postgresql

#########
# Redis #
#########
# sudo apt install redis-server



##########
# Apache #
##########
# sudo apt install apache2
# sudo a2enmod ssl rewrite


#######
# PHP #
#######
## If we want to make sure we get the very latest PHP stuff, add this PPA.
# sudo apt-add-repository -y ppa:ondrej/php
# sudo apt install php php-pear php-cli php-json php-mysql php-pgsql php-sqlite3 php-dev php-mongodb php-xdebug php-curl php-gd php-mcrypt 
# sudo php7enmod mcrypt
# sudo service apache2 restart

## Composer
# php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
# php composer-setup.php --install-dir=$HOME/progs/bin
# php -r "unlink('composer-setup.php');"
# chmod +x $HOME/progs/bin/composer.phar

## PHP CodeSniffer (phpcs) and Mess Detector (phpmd)
# $HOME/progs/bin/composer.phar global require "squizlabs/php_codesniffer=*"
# $HOME/progs/bin/composer.phar global require "phpmd/phpmd=*"



#######################################################
## Powerline (https://github.com/powerline/powerline) #
#######################################################
sudo apt install powerline fonts-powerline python-powerline python3-powerline python-pygit2 python3-pygit2
cat >> .bashrc << EOF

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh
EOF

mkdir -p $HOME/.config/powerline/themes/shell
cat > $HOME/.config/powerline/config.json << EOF
{
    "ext": {
        "shell": {
            "theme": "default_leftonly"
        }
    }
}
EOF

# Write Powerline shell theme configuration to change the default segments order
cat > $HOME/.config/powerline/themes/shell/default_leftonly.json << EOF
{
    "segments": {
        "left": [
            {
                "function": "powerline.segments.common.net.hostname",
                "priority": 10
            },
            {
                "function": "powerline.segments.common.env.user",
                "priority": 30
            },
            {
                "function": "powerline.segments.shell.cwd",
                "priority": 10
            },
            {
                "function": "powerline.segments.common.env.virtualenv",
                "priority": 50
            },
            {
                "function": "powerline.segments.common.vcs.branch",
                "priority": 40
            },
            {
                "function": "powerline.segments.shell.jobnum",
                "priority": 20
            },
            {
                "function": "powerline.segments.shell.last_status",
                "priority": 10
            }
        ]
    },
    "segment_data": {
        "powerline.segments.common.vcs.branch": {
            "args": {
                "status_colors": true,
                "ignore_statuses": ["U"]
            }

        }
    }
}
EOF


## Clean up
echo "Cleaning Up" &&
popd &&
rm -rf $HOME/new_ubuntu_temp_and_a_random_string &&
sudo apt -f install &&
sudo apt autoremove &&
sudo apt -y autoclean &&
sudo apt -y clean