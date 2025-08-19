#!/bin/bash

## Assuming Linux Mint 22. Should also mostly work with Ubuntu 24.04

set -euxo pipefail

UBUNTU_CODENAME=noble

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

printf "\n--> libdvd-pkg needs dpkg-reconfigure...\n" &&
sudo dpkg-reconfigure -f noninteractive libdvd-pkg &&

printf "\n--> Running special installers:\n" &&
pushd ./temp &&

printf "\n--> Installing oh-my-zsh...\n" &&
sh -c "$(curl --proto '=https' --tlsv1.2 -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &&

printf "\n--> Installing Atuin...\n" &&
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh &&

printf "\n--> Installing pnpm...\n" &&
curl --proto '=https' --tlsv1.2 -fsSL https://get.pnpm.io/install.sh | sh - &&

printf "\n--> Installing node...\n" &&
pnpm env use --global 18 &&

printf "\n--> Installing uv...\n" &&
curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh | sh &&
echo 'eval "$(uv generate-shell-completion zsh)"' >> ~/.zshrc &&


printf "\n--> Installing Rust and related goodies...\n" &&
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh &&
source $HOME/.cargo/env &&
cargo install eza ripgrep bat fd-find procs du-dust bottom bandwhich grex git-delta starship gitui xh diskonaut zellij alacritty &&

printf "\n--> Git configuration\n" &&
git config --global alias.up "pull --rebase --autostash" &&
git config --global user.signingkey 55F9BCEB7472D59C &&
git config --global commit.gpgSign true &&

printf "\n--> Set up git delta\n" &&
git config --global core.pager delta &&
git config --global interactive.diffFilter "delta --color-only --features=interactive" &&
git config --global delta.navigate true &&
git config --global delta.light false &&
git config --global delta.line-numbers true &&
git config --global delta.side-by-side true &&
git config --global delta.keep-plus-minus-markers false &&
git config --global delta.hunk-header-style "file line-number syntax" &&



printf "\n--> Setting up aliases for ls -> eza, grep -> rg, and cat -> bat...\n" &&
echo 'alias ls="eza --icons -g"' >> $HOME/.zshrc &&
echo 'alias grep="rg"' >> $HOME/.zshrc &&
echo 'alias cat="bat"' >> $HOME/.zshrc &&

printf "\n--> Installing zoxide...\n" &&
curl --proto '=https' --tlsv1.2 -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh &&

printf "\n--> Installing fzf...\n" &&
$HOME/.fzf/install --key-bindings --completion --update-rc &&

printf "\n--> Installing mise-en-place...\n" &&
curl --proto '=https' --tlsv1.2 https://mise.run | sh &&
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc &&

printf "\n--> Installing chezmoi...\n" &&
sh -c "$(curl --proto '=https' --tlsv1.2 -fsLS get.chezmoi.io)" &&

# Install Go
printf "\n--> Installing Go...\n" &&
curl --proto '=https' --tlsv1.2 -sSfL https://go.dev/dl/go1.25.0.linux-amd64.tar.gz -o /tmp/go1.25.0.linux-amd64.tar.gz &&
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.25.0.linux-amd64.tar.gz && rm -rf /tmp/go1.25.0.linux-amd64.tar.gz &&

printf "\n--> Installing fish shell...\n" &&
sudo add-apt-repository -y ppa:fish-shell/release-4 &&
sudo apt update -y &&
sudo apt install fish &&

printf "\n--> Installing neovim...\n" &&
curl --proto '=https' --tlsv1.2 -fsLSO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz &&
rm -rf ~/progs/nvim &&
tar -C ~/progs -xzf nvim-linux-x86_64.tar.gz &&

## Clean up
popd &&
printf "\nRemoving temporary directory..." &&
rm -rf ./temp &&
printf "\n--> All done!\n"

printf "\n\n NOTE \nIf you're on Linux Mint, install the following packages as well:\n"
printf "mintsources\n"
printf "warpinator\n\n"
printf "Here's a command you can copy&paste:\n"
printf "sudo apt install mintsources warpinator\n\n"

printf "Other things you need to install:\n"
printf "- Slack\n"
printf "- IDEs"
printf "- Steam\n"
