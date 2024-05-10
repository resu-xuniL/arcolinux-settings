#!/bin/bash

sudo find /usr/share/oh-my-zsh/themes/ -type f -name "*.zsh-theme" -exec sed -i -E "s/%a,%b%d|%a %b %d/%a %d %b/" '{}' \;
sudo find /usr/share/oh-my-zsh/themes/ -type f -name "*.zsh-theme" -exec sed -i "s/%Y-%m-%d/%d-%m-%Y/" '{}' \;

tput setaf 3
echo "Date format edited on Oh-my-ZSH themes"
tput sgr0