#!/bin/bash

mkdir ~/oh_my_zsh && cd ~/oh_my_zsh

echo -e "\nDownloading fonts\n"
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh

echo -e "\nInstalling brew\n"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


echo -e "\nInstalling iterm2 and zsh\n"
brew cask install iterm2
brew install zsh

echo -e "\nInstalling oh-my-zsh\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo -e "\nInstalling powerlevel10k theme and few important plugins\n"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo -e "\nFollow the below steps and update the ~/.zshrc file\n"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=( git zsh-syntax-highlighting zsh-autosuggestions )

echo "Run this from iterm2"
source ~/.zshrc
