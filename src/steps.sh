step() {
    local -r function=$1
    local -r message=$2
    local dash_line=""

    for (( i=0; i<${#message}; i++ )); 
        do dash_line+="-" ; 
    done

    printf "\n%s\n%s\n\n" "${YELLOW}${message}" "${dash_line}${RESET}"

    ${function}
}

display_step() {
    local -r message="$1"
    local -r width="$(( $(tput cols) / 2 ))"
    clear

    printf "${YELLOW}"
    for i in $(seq 1 ${width}); do
        printf "%0.1s" "#";
    done
    printf "\n"
    center_text "${message}" "${width}"
    printf "\n"
    for i in $(seq 1 ${width}); do
        printf "%0.1s" "#";
    done
    printf "\n${RESET}"
}

choose_steps() {
    steps_sel=$(whiptail \
        --separate-output \
        --title "Step(s) to execute" \
        --checklist "Choose steps :" 10 60 0 \
        "1" "Step 1 : Uninstall" OFF \
        "2" "Step 2 : System update" OFF \
        "3" "Step 3 : Install" OFF \
        "4" "Step 4 : Configuration" OFF \
        "5" "All steps" ON 3>&1 1>&2 2>&3
    )

    if [ -z "${steps_sel}" ]; then
         printf "%b\n\n" "\033[2B${RED}No option was selected${RESET} (user hit Cancel or unselected all options)"
    else
        for step_sel in ${steps_sel}; do
            case "${step_sel}" in
            1 )
                # Uninstall
                display_step "Software uninstallation"
                sleep 1
                step uninstall_software "Software uninstallation"
                prompt_to_continue
                ;;
            2 )
                # Update system
                display_step "Updating system"
                sleep 1
                step update_system      "Updating system"
                prompt_to_continue
                ;;
            3 )
                # Install
                display_step "Software installation"
                sleep 1
                step install_software   "Software installation"
                prompt_to_continue
                ;;
            4 )
                # Configuration
                display_step "System configuration"
                sleep 1
                step config_files       "Files system configuration"
                step config_settings    "System configuration"
                prompt_to_continue
                ;;
            5 )
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