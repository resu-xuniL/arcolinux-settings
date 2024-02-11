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
change_xfce_terminal_display

if grep -q "ArcoLinux" /etc/os-release; then

    # choice
    header
    prompt_to_continue

    all_steps() {
        # init
        display_step "Initialization"
        sleep 1
        step init               "Initialization"
        prompt_to_continue

        # Uninstall
        display_step "Software uninstallation"
        sleep 1
        step uninstall_software "Software uninstallation"
        prompt_to_continue

        # Update system
        display_step "Updating system"
        sleep 1
        step update_system      "Updating system"
        prompt_to_continue

        # Install
        display_step "Software installation"
        sleep 1
        step install_software   "Software installation"
        prompt_to_continue

        # Configuration
        display_step "System configuration"
        sleep 1
        step config_files       "Files system configuration"
        step config_settings    "System configuration"
        prompt_to_continue

        # End
        sleep 1
        endscript "${start_time}"
    }

    choose_steps
else
    exec_log "xfconf-query -c xfce4-terminal -p /background-darkness -s 0.85" "${GREEN}[+]${RESET} XFCE terminal : Restoring [${YELLOW}BACKGROUND DARKNESS${RESET}] to [${YELLOW}0.85${RESET}]"
    exec_log "xfconf-query -c xfce4-terminal -p /font-use-system -s true" "${GREEN}[+]${RESET} XFCE terminal : Restoring use of system [${YELLOW}FONT${RESET}] to [${YELLOW}TRUE${RESET}]"
    exec_log "exit 1" "\n${RED}/!\ THIS IS NOT AN [${RESET}${BOLD}${BLINK}${YELLOW}ARCOLINUX${RESET}${RED}] DISTRO /!\ ${RESET}\n"
fi