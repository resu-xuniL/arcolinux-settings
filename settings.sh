#!/usr/bin/env bash

source src/opt.sh
source src/init.sh
source src/header.sh
source src/steps.sh
source src/cmd.sh
source src/cmd_main.sh
source src/_dep.sh
source src/_uninstall.sh
source src/_install.sh
source src/_config_settings.sh
source src/_config_files.sh
source src/end.sh

start_time="$(date +%s)"
LOG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/logfile_$(date "+%Y%m%d-%H%M%S").log"

start_step() {
    check_internet || exit 1
    change_xfce_terminal_display
}

if [[ ${CURRENT_OS} == "ArcoLinux" || ${CURRENT_OS} == "Arch Linux" ]]; then
    if [[ -z ${XDG_CURRENT_DESKTOP} ]]; then
        log_msg "${RED}/!\ RUN [${RESET}${BB}${YELLOW}arch.sh${RESET}${RED}] SCRIPT FIRST /!\ ${RESET}\n"
        exit
    fi

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

    if [[ ${INSTALLMODE} == "true" ]]; then
        display_step "INSTALL MODE"
        step install_step "Install step mode"
        restore_xfce_terminal_display
        exit 0;
    fi

    if [[ ${UNINSTALLMODE} == "true" ]]; then
        display_step "UNINSTALL MODE"
        step uninstall_step "Uninstall step mode"
        restore_xfce_terminal_display
        exit 0;
    fi

    if [[ ${CONFIGMODE} == "true" ]]; then
        display_step "CONFIGURATION MODE"
        step configuration_step "Configutation step mode"
        restore_xfce_terminal_display
        exit 0;
    fi

    all_steps
else
    log_msg "${RED}/!\ THIS IS NOT AN [${RESET}${BB}${YELLOW}ARCH LINUX${RESET}${RED}] NOR AN [${RESET}${BB}${YELLOW}ARCOLINUX${RESET}${RED}] DISTRO /!\ ${RESET}\n"
    exit
fi