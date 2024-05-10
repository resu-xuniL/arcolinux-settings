#!/bin/bash

if grep -q "arcolinux-settings_repo" /etc/pacman.conf; then
  echo "arcolinux-settings_repo is already in /etc/pacman.conf"
else
echo '

[arcolinux-settings_repo]
SigLevel = Optional TrustedOnly
Server = https://resu-xunil.github.io/$repo/$arch' | sudo tee -a /etc/pacman.conf

tput setaf 3
echo "Added arcolinux-settings_repo in /etc/pacman.conf"
tput sgr0
fi


# if grep -q "arcolinux-settings_repo_test" /etc/pacman.conf; then
#   echo "arcolinux-settings_repo is already in /etc/pacman.conf"
# else
# echo '

# [arcolinux-settings_repo_test]
# SigLevel = Optional TrustedOnly
# Server = https://resu-xunil.github.io/$repo/$arch' | sudo tee -a /etc/pacman.conf

# tput setaf 3
# echo "Added arcolinux-settings_repo_test in /etc/pacman.conf"
# tput sgr0
# fi
