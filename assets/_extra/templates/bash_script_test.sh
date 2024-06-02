#!/bin/bash

export RESET=$(tput sgr0)
export BLINK=$(tput blink)
export BOLD=$(tput bold)
export BB=$(tput blink; tput bold)
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export BLUE=$(tput setaf 4)
export PURPLE=$(tput setaf 5)

export INSTALL_DIRECTORY=$(dirname $(readlink -f $(basename `pwd`)))/assets
export CURRENT_USER=$(whoami)
export CURRENT_RESOLUTION=$(xdpyinfo | grep dimensions: | awk '{print $2}')
export CURRENT_OS=$(cat /etc/os-release | grep NAME | cut -d '=' -f 2 | uniq | tr -d \")
export VM=$(systemd-detect-virt)
export CHASSIS=$(hostnamectl chassis)
export PASSWORD=""

if sudo -v; then
    printf "\n%s\n" "${GREEN}[OK]${RESET} Root privileges granted"
else
    printf "\n%s\n" "${RED}[KO]${RESET} Root privileges denied"
    exit 1
fi

##################################################################################################################








##################################################################################################################
