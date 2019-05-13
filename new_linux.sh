#!/bin/bash

## Assuming Linux Mint 19. Should also mostly work with Ubuntu 18.04

## Installing .deb packages could be done in a single go if I added the
## necessary repositories beforehand but this way the script is more
## modular and I can comment out any sections if I want to.

## TODO: Rewrite this with Salt/Ansible?


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
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install acpi gimp inkscape shutter vim unace unace-nonfree unrar p7zip-full curl wget whois synaptic python-software-properties openjdk-11-jre openjdk-11-jre-headless gparted compizconfig-settings-manager clamav-freshclam clamav chkrootkit rkhunter gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad libavcodec-extra ubuntu-restricted-extras bash-completion ttf-mscorefonts-installer htop apt-transport-https

############################
# libdvdcss and latest VLC #
############################
sudo apt-get -y install libdvd-pkg vlc
sudo dpkg-reconfigure libdvd-pkg


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


#######
# Git #
#######
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get install git
git config --global alias.up 'pull --rebase --autostash'
git config --global user.signingkey #######
git config --global gpg.program /usr/bin/gpg2
git config --global commit.gpgSign true



##########
# Python #
##########
sudo apt-get install -y python-pip python-setuptools python-wheel python-all-dev python3-pip python3-setuptools python3-wheel python3-all-dev
pip3 install --user -U pipenv

sudo apt-get install -y libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev  llvm libncurses5-dev libncursesw5-dev xz-utils
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
cat >> .zshrc << EOF

export PATH="/home/borfast/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOF


########
# Node #
########
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get -y update && sudo apt-get -y install yarn

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
curl -o ./studio3t.tar.gz https://download.studio3t.com/studio-3t/linux/2019.2.1/studio-3t-linux-x64.tar.gz &&
tar -C $HOME/progs/ -xzf studio3t.tar.gz
rm -rf ./studio3t.tar.gz



#######################################################
## ZShell #
#######################################################
sudo apt-get install fonts-powerline zsh zsh-theme-powerlevel9k
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel9k\/powerlevel9k"/' $HOME/.zshrc


## Clean up
echo "Cleaning Up" &&
popd &&
rm -rf $HOME/new_ubuntu_temp_and_a_random_string &&
sudo apt-get -f install &&
sudo apt-get autoremove &&
sudo apt-get -y autoclean &&
sudo apt-get -y clean