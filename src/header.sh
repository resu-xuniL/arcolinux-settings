header() {
    clear
    cat <<-EOF
----------------------------------------------------------------------------------------------------

        ${PURPLE}##${RESET}                         ${GREEN}##${RESET} 
        ${PURPLE}##     ##${RESET}    ${GREEN}###    ###   ###${RESET} 
        ${PURPLE}##  #  ##${RESET}  ${GREEN}##   ##  #### ####${RESET}          Script configuration for ArcoLinux
        ${PURPLE}## ### ##${RESET} ${GREEN}##     ## ## ### ##${RESET} 
        ${PURPLE}#### ####${RESET} ${GREEN}######### ##  #  ##${RESET} 
        ${PURPLE}###   ###${RESET} ${GREEN}##     ## ##     ##${RESET}          https://github.com/resu-xuniL/arcolinux-settings
        ${PURPLE}##     ##${RESET} ${GREEN}##     ## ##     ##${RESET} 

----------------------------------------------------------------------------------------------------
EOF

    sleep 1
    
    printf "${BOLD}${RED}"
    center_text "/!\ THIS SCRIPT WILL MAKE CHANGES TO THE SYSTEM ! /!\\" "$(tput cols)"
    printf "${RESET}"
    center_text "(Some steps may take longer, depending on your Internet connection and CPU.)" "$(tput cols)"
    printf "%b" "\033[5B"
}

choose_steps() {
    steps_sel=$(whiptail \
        --separate-output \
        --title "Step(s) to execute" \
        --checklist "Choose steps :" 10 60 0 \
        "1" "Step 1 : Init" OFF \
        "2" "Step 2 : Uninstall" OFF \
        "3" "Step 3 : System update" OFF \
        "4" "Step 4 : Install" OFF \
        "5" "Step 5 : Configuration" OFF \
        "6" "Step 6 : End" OFF \
        "7" "All steps" ON 3>&1 1>&2 2>&3
    )

    if [ -z "${steps_sel}" ]; then
         printf "%b\n\n" "\033[2B${RED}No option was selected${RESET} (user hit Cancel or unselected all options)"
    else
        for step_sel in ${steps_sel}; do
            case "${step_sel}" in
            1 )
                header
                prompt_to_continue
                choose_step
                ;;
            2 )
                # Uninstall
                display_step "Software uninstallation"
                sleep 1
                step uninstall_software "Software uninstallation"
                prompt_to_continue
                ;;
            3 )
                # Update system
                display_step "Updating system"
                sleep 1
                step update_system      "Updating system"
                prompt_to_continue
                ;;
            4 )
                # Install
                display_step "Software installation"
                sleep 1
                step install_software   "Software installation"
                prompt_to_continue
                ;;
            5 )
                # Configuration
                display_step "System configuration"
                sleep 1
                step config_files       "Files system configuration"
                step config_settings    "System configuration"
                prompt_to_continue
                ;;
            6 )
                # End
                sleep 1
                endscript "${start_time}"
                ;;
            7 )
                all_steps
                ;;
            *)
                printf "%b\n" "Unsupported item ${step_sel}!" >&2
                exit 1
                ;;
            esac
        done
    fi
}