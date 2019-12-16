#!/bin/bash

## Assuming Linux Mint 19. Should also mostly work with Ubuntu 18.04

## Installing .deb packages could be done in a single go if I added the
## necessary repositories beforehand but this way the script is more
## modular and I can comment out any sections if I want to.

## TODO: Rewrite this with Salt/Ansible?

UBUNTU_CODENAME=bionic


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
sudo add-apt-repository -y ppa:inkscape.dev/stable
sudo add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install ca-certificates gnupg-agent software-properties-common snapd qbittorrent acpi gimp inkscape shutter vim unace unace-nonfree unrar p7zip-full curl wget whois synaptic python-software-properties openjdk-11-jre openjdk-11-jre-headless gparted compizconfig-settings-manager clamav-freshclam clamav chkrootkit rkhunter gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad libavcodec-extra ubuntu-restricted-extras bash-completion ttf-mscorefonts-installer htop apt-transport-https mesa-vulkan-drivers vdpau-va-driver vdpauinfo nethogs vokoscreen

############################
# libdvdcss and latest VLC #
############################
sudo apt-get -y install libdvd-pkg vlc
sudo dpkg-reconfigure libdvd-pkg

##############################
# Hugo static site generator #
##############################
snap install hugo --channel=extended


#################
# Google Chrome #
#################
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
sudo dpkg -i google-chrome-stable_current_amd64.deb &&
rm -f google-chrome-stable_current_amd64.deb


####################
# Development shit #
####################
sudo apt-get -y install make build-essential git gitg git-cola openjdk-11-jdk terminator meld mysql-client postgresql-client postgresql-contrib pgadmin3 ruby ruby-dev mysql-workbench libsqlite3-dev libmysqlclient-dev libpq-dev redis-tools

##############
# Virtualbox #
##############
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $UBUNTU_CODENAME contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y virtualbox-6.0 virtualbox-guest-x11

curl -O https://download.virtualbox.org/virtualbox/6.0.14/Oracle_VM_VirtualBox_Extension_Pack-6.0.14.vbox-extpack
VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-6.0.14.vbox-extpack

curl -O https://download.virtualbox.org/virtualbox/6.0.14/VBoxGuestAdditions_6.0.14.iso


#######
# Git #
#######
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get install git
git config --global alias.up 'pull --rebase --autostash'
git config --global user.signingkey #######
git config --global commit.gpgSign true



##########
# Python #
##########
sudo apt-get install -y python-pip python-setuptools python-wheel python-all-dev python-venv python3-pip python3-setuptools python3-wheel python3-all-dev python3-venv libffi-dev
python3 -m pip install --user -U pipenv pipx
python3 -m pipx ensurepath

sudo apt-get install -y libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev  llvm libncurses5-dev libncursesw5-dev xz-utils
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
cat >> .zshrc << EOF

export PATH="/home/borfast/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOF


#######################################################################################################################
# Docker - as instructed at https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-engine---community #
#######################################################################################################################
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io


########
# Node #
########
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm add -g pnpm

curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get -y update && sudo apt-get -y install yarn
echo "export PATH=\"$(yarn global bin):\$PATH\"" >> .zshrc

########
# Java #
########
# webupd8team java PPA removed because it is discontinued. Switch to Amazon Corretto?


#################################################
# MailHog - https://github.com/mailhog/MailHog/ #
#################################################
curl -L -o $HOME/progs/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
chmod u+x $HOME/progs/bin/mailhog


###########################
# Studio 3T (for Mongodb) #
###########################
curl -o ./studio3t.tar.gz https://download.studio3t.com/studio-3t/linux/2019.6.1/studio-3t-linux-x64.tar.gz &&
tar -C $HOME/progs/ -xzf studio3t.tar.gz
rm -rf ./studio3t.tar.gz



#######################################################
## ZShell #
#######################################################
sudo apt-get install fonts-powerline zsh zsh-theme-powerlevel9k
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "source /usr/share/powerlevel9k/powerlevel9k.zsh-theme" >> $HOME/.zshrc


## Clean up
echo "Cleaning Up" &&
popd &&
rm -rf $HOME/new_ubuntu_temp_and_a_random_string &&
sudo apt-get -f install &&
sudo apt-get autoremove &&
sudo apt-get -y autoclean &&
sudo apt-get -y clean
