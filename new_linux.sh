#!/bin/bash

## Assuming Linux Mint 20. Should also mostly work with Ubuntu 20.04

UBUNTU_CODENAME=focal

# Install Ansible first, so we can run the playbook
sudo apt update &&
printf "\n--> Installing software-properties-common...\n" &&
sudo apt install -y software-properties-common &&
printf "\n--> Adding Ansible's repository...\n" &&
sudo apt-add-repository -y ppa:ansible/ansible &&
printf "\n--> Updating package cache...\n" &&
sudo apt update &&
printf "\n--> Installing Ansible...\n" &&
sudo apt install ansible -y &&
printf "\n--> Installing Ansible community.general collection...\n" &&
ansible-galaxy collection install community.general &&
printf "\n--> Running Ansible playbook - this is the big one!\n" &&
ansible-playbook ansible-playbook.yml --ask-become-pass &&

printf "\n--> Running special installers:\n" &&
pushd ./temp &&

printf "\n--> Installing pyenv...\n" &&
./pyenv-installer

printf "\n--> Installing poetry...\n" &&
python3 ./install-poetry.py &&

printf "\n--> Installing Rust...\n" &&
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh &&
cargo install exa ripgrep bat fd-find procs du-dust bottom bandwhich grex git-delta &&
echo 'alias ls="exa"' >> $HOME/.zshrc &&
echo 'alias grep="rg"' >> $HOME/.zshrc &&
echo 'alias cat="bat"' >> $HOME/.zshrc &&

printf "\n--> Installing fzf...\n" &&
$HOEM/.fzf/install --key-bindings --completion --no-fish --update-rc &&

## Clean up
popd &&
printf "\nRemoving temporary directory..." &&
rm -rf ./temp &&
printf "\n--> All done!\n"
