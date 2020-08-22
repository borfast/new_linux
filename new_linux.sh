#!/bin/bash

## Assuming Linux Mint 20. Should also mostly work with Ubuntu 20.04

## Installing .deb packages could be done in a single go if I added the
## necessary repositories beforehand but this way the script is more
## modular and I can comment out any sections if I want to.

## TODO: Rewrite this with Salt/Ansible?

UBUNTU_CODENAME=focal


# Create the user bin folder and add it to the PATH
mkdir -p $HOME/progs/bin
echo "PATH DEFAULT=${PATH}:${HOME}/progs/bin" >> $HOME/.pam_environment
export PATH="$PATH:$HOME/progs/bin"

# Let's work in a temporary directory that is destroyed at the end of the script
mkdir $HOME/new_ubuntu_temp_and_a_random_string
pushd $HOME/new_ubuntu_temp_and_a_random_string


####################
# PPAs to be added #
####################
PPAS=(
	ppa:inkscape.dev/stable
	ppa:qbittorrent-team/qbittorrent-stable
	ppa:git-core/ppa
)

# Add the PPAs listed before
for ppa in ${PPAS[*]}
do
	sudo add-apt-repository -y $ppa
done


#################################
# Packages by category, just to #
# make it easier to find stuff. #
#################################

DEVELOPMENT=(
	build-essential
	git
	gitg
	git-cola
	libbz2-dev
	libffi-dev
	libmysqlclient-dev
	libncurses-dev
	libsqlite3-dev
	libpq-dev
	libreadline-dev
	libsqlite3-dev
	libssl-dev
	llvm
	make
	meld
	mysql-client
	openjdk-11-jdk
	openjdk-11-jre
	openjdk-11-jre-headless
	postgresql-client
	postgresql-contrib
	pgadmin3
	python-pip-whl
	python3-setuptools
	python3-wheel
	python3-all-dev
	python3-venv
	python3-pip
	redis-tools
	ruby
	ruby-dev
	xz-utils
	zlib1g-dev
)

GRAPHICS=(
	gimp
	inkscape
	flameshot
)

INTERNET=(
	qbittorrent
)

MULTIMEDIA=(
	gstreamer1.0-plugins-base
	gstreamer1.0-plugins-good
	gstreamer1.0-plugins-ugly
	gstreamer1.0-plugins-bad
	libavcodec-extra
	libdvd-pkg
	ubuntu-restricted-extras
	vlc
	vokoscreen
)

SECURITY=(
	clamav
	clamav-freshclam
	chkrootkit
	rkhunter
)

SYSTEM=(
	acpi
	apt-transport-https
	bash-completion
	ca-certificates
	gnupg-agent
	mesa-vulkan-drivers
	mesa-va-drivers
	mintsources
	python3-software-properties
	snapd
	ttf-mscorefonts-installer
	vdpauinfo
)

UTILS=(
	compizconfig-settings-manager
	curl
	gparted
	htop
	nethogs
	p7zip-full
	synaptic
	terminator
	unace
	unace-nonfree
	unrar
	vim
	wget
	whois
)

# Merge all the package groups together
PACKAGES=(
	"${DEVELOPMENT[@]}"
	"${GRAPHICS[@]}"
	"${INTERNET[@]}"
	"${MULTIMEDIA[@]}"
	"${SECURITY[@]}"
	"${SYSTEM[@]}"
	"${UTILS[@]}"
)



# Update and upgrade all the things.
sudo apt-get update
sudo apt-get -y upgrade

# Install all the packages
sudo apt-get -y install "${PACKAGES[@]}"



#########################################
# From here on we install and configure #
# stuff # that requires special steps.  #
#########################################



#########################
# libdvd-pkg needs this #
#########################
sudo dpkg-reconfigure libdvd-pkg

##############################
# Hugo static site generator #
##############################
curl -L -O https://github.com/gohugoio/hugo/releases/download/v0.74.3/hugo_0.74.3_Linux-64bit.deb &&
sudo dpkg -i hugo_0.74.3_Linux-64bit.deb &&
rm -f hugo_0.74.3_Linux-64bit.deb

###########
# DBeaver #
###########
curl -L -O https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb &&
sudo dpkg -i dbeaver-ce_latest_amd64.deb &&
rm -f dbeaver-ce_latest_amd64.deb


#################
# Google Chrome #
#################
curl -L -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
sudo dpkg -i google-chrome-stable_current_amd64.deb &&
rm -f google-chrome-stable_current_amd64.deb


##############
# Virtualbox #
##############
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $UBUNTU_CODENAME contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y virtualbox-6.1 virtualbox-guest-x11

curl -L -O https://download.virtualbox.org/virtualbox/6.1.12/Oracle_VM_VirtualBox_Extension_Pack-6.1.12.vbox-extpack
VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-6.1.12.vbox-extpack

curl -L -O https://download.virtualbox.org/virtualbox/6.1.12/VBoxGuestAdditions_6.1.12.iso


#######
# Git #
#######
git config --global alias.up 'pull --rebase --autostash'
git config --global user.signingkey #######
git config --global commit.gpgSign true



################
# Python stuff #
################
python3 -m pip install --user -U pipenv pipx
python3 -m pipx ensurepath

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


#######################
# Node, pnpm and yarn #
#######################
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
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
curl -L -o $HOME/progs/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64
chmod u+x $HOME/progs/bin/mailhog


###########################
# Studio 3T (for Mongodb) #
###########################
curl -o ./studio3t.tar.gz https://download.studio3t.com/studio-3t/linux/2020.7.1/studio-3t-linux-x64.tar.gz &&
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
