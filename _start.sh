#!/usr/bin/env bash

source src/init.sh
source src/header.sh
source src/cmd.sh
source src/cmd_main.sh
source src/_uninstall.sh
source src/_install.sh
source src/_settings.sh
source src/_files.sh
source src/end.sh

start_time="$(date +%s)"
LOG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/logfile_$(date "+%Y%m%d-%H%M%S").log"

check_internet || exit 1

if grep -q "ArcoLinux" /etc/os-release; then

    # init
    display_step "Initialization"
    sleep 1
    init_log
    step init "Initialization\n--------------\n"
    header

    # Uninstall
    display_step "Software uninstallation"
    sleep 1
    step uninstall_software     "Software uninstallation\n-----------------------\n"

    # Update system
    display_step "Updating system"
    sleep 1
    step update_system          "Updating system\n---------------\n"

    # Install
    display_step "Software installation"
    sleep 1
    step install_software       "Software installation\n---------------------"

    # Configuration
    display_step "System configuration"
    sleep 1
    step config_files              "Files system configuration\n--------------------------"
    step config_settings           "System configuration\n--------------------"

    # End
    sleep 1
    endscript "${start_time}"
else
    exec_log "exit 1" "\n${RED}/!\ THIS IS NOT AN [${RESET}${YELLOW}ARCOLINUX${RESET}${RED}] DISTRO /!\ ${RESET}\n"
fi