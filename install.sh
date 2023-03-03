#!/bin/bash

set -uxo pipefail 

# Checking architecture

architecture='unknown'
unamestr=$(uname -m)
if [[ "$unamestr" == 'aarch64' ]]; then
	architecture='arm64'
elif [[ "$unamestr" == 'x86_64' ]]; then
	architecture='amd64'
fi

# Base Install

echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf

sudo dnf check-update && sudo dnf upgrade -y
sudo dnf install -y git wget curl zsh tmux p7zip unzip unrar htop neofetch keychain vim neovim python3-neovim ripgrep fd-find util-linux-user fzf net-tools gcc-c++ nodejs
sudo dnf groupinstall -y "Development Tools" "Development Libraries"

# Tools Install 

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

cargo install tree-sitter-cli

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
	--add-repo \
	https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker jasyuiop
sudo systemctl enable docker

if [[ $architecture == 'arm64' ]]; then
	wget https://go.dev/dl/go1.20.1.linux-arm64.tar.gz && sudo tar -C /usr/local -xzf go1.20.1.linux-arm64.tar.gz
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
elif [[ $architecture == 'amd64' ]]; then
	wget https://go.dev/dl/go1.20.1.linux-amd64.tar.gz && sudo tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
fi

export PATH=$PATH:/usr/local/go/bin
sudo install minikube-linux-arm64 /usr/local/bin/minikube
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

go install github.com/lemonade-command/lemonade@latest

# User Configuration Pre Install 

ssh-keygen -t ed25519 -C "emrenefesli@outlook.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
read -p "Add key to github and press enter"
ssh -T git@github.com

/usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone git@github.com:jasyuiop/nvim.git ~/.config/nvim

tee -a ~/.ssh/config <<END
Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
END

# Get Configuration From Github

git clone --bare git@github.com:jasyuiop/dotfilesForMyHeadless.git $HOME/.cfg
function dotfiles {
	/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
mkdir -p .config-backup
dotfiles checkout
if [ $? = 0 ]; then
	echo "Checked out config."
else
	echo "Backing up pre-existing dot files."
	dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi
dotfiles checkout
dotfiles config status.showUntrackedFiles no

echo "Finish... Bye..."
