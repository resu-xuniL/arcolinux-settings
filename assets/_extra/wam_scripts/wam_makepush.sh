#!/bin/bash

tput setaf 2
echo "###############################################################################"
echo "################## Building package"
echo "###############################################################################"
echo
tput sgr0
makepkg --dir "${HOME}/Documents/[Nextcloud]/[Linux]/[Scripts]/arcolinux-settings_pkgbuild/pkgbuild"
echo

tput setaf 2
echo "###############################################################################"
echo "################## Git push to repo"
echo "###############################################################################"
echo
tput sgr0
cd "${HOME}/Documents/[Nextcloud]/[Linux]/[Scripts]/arcolinux-settings_repo" && ./up.sh
echo

tput setaf 2
echo "###############################################################################"
echo "################## Done !"
echo "###############################################################################"
echo
tput sgr0
