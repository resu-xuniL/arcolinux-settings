#!/usr/bin/env bash

source src/init.sh
source src/header.sh
source src/steps.sh
source src/cmd.sh
source src/cmd_main.sh
source src/_uninstall.sh
source src/_install.sh
source src/_settings.sh
source src/_files.sh
source src/end.sh

start_time="$(date +%s)"
LOG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/logfile_$(date "+%Y%m%d-%H%M%S").log"

start_step() {
    check_internet || exit 1
    change_xfce_terminal_display
}

if grep -q "ArcoLinux" /etc/os-release; then

    all_steps() {
        start_step
        header_step
        init_step
        uninstall_step
        update_step
        install_step
        configuration_step
        end_step
    }

    header_step() {
        # Start
        header
        prompt_to_continue
    }
    
    init_step() {
        # init
        display_step "Initialization"
        sleep 1
        step init "Initialization"
        prompt_to_continue
    }

    uninstall_step() {
        # Uninstall
        display_step "Software uninstallation"
        sleep 1
        step uninstall_software "Software uninstallation"
        prompt_to_continue
    }

    update_step() {
        # Update system
        display_step "Updating system"
        sleep 1
        step update_system "Updating system"
        prompt_to_continue
    }

    install_step() {
        # Install
        display_step "Software installation"
        sleep 1
        step install_software "Software installation"
        prompt_to_continue
    }

    configuration_step() {
        # Configuration
        display_step "System configuration"
        sleep 1
        step config_files "Files system configuration"
        step config_settings "System configuration"
        prompt_to_continue
    }
            
    end_step() {
        # End
        sleep 1
        endscript "${start_time}"
    }

    if [[ ${TESTMODE} == "true" ]]; then
        start_step
        display_step "TEST MODE"
        step steps_selection "Testing step(s) mode"
        restore_xfce_terminal_display
        exit 0;
    fi

    if [[ ${GUIMODE} == "true" ]]; then
        start_step
        display_step "TEST MODE"
        step gui_steps_selection "Testing step(s) mode"
        restore_xfce_terminal_display
        exit 0;
    fi   

    all_steps

else
    restore_xfce_terminal_display

    exec_log "exit 1" "\n${RED}/!\ THIS IS NOT AN [${RESET}${BB}${YELLOW}ARCOLINUX${RESET}${RED}] DISTRO /!\ ${RESET}\n"
fi