declare -A step_list

selected_packages=""

set_step_list() {
    step_order=(
        [1]="Start"
        [2]="Header"
        [3]="Init"
        [4]="Uninstall"
        [5]="System update"
        [6]="Install"
        [7]="Configuration"
        [8]="End"
    )

    step_list=(
        [Start]="start_step"
        [Header]="header_step"
        [Init]="init_step"
        [Uninstall]="uninstall_step"
        [System update]="update_step"
        [Install]="install_step"
        [Configuration]="configuration_step"
        [End]="end_step"
    )
}
 

steps_selection() {
    action_type="steps"
    
    set_step_list

    select_from_list step_list "Choose step(s) to execute" step_order

    local -r packages="${selected_packages}"

    selected_packages=""

    manage_lst "${packages}"
}

gui_steps_selection() {
    steps_sel=$(whiptail \
        --separate-output \
        --title "Step(s) to execute" \
        --checklist "Choose steps :" 10 60 0 \
        "1" "Step 1 : Start" OFF \
        "2" "Step 2 : Header" OFF \
        "3" "Step 3 : Init" OFF \
        "4" "Step 4 : Uninstall" OFF \
        "5" "Step 5 : System update" OFF \
        "6" "Step 6 : Install" OFF \
        "7" "Step 7 : Configuration" OFF \
        "8" "Step 8 : End" OFF \
        "9" "All steps" ON 3>&1 1>&2 2>&3
    )

    if [ -z "${steps_sel}" ]; then
         printf "%b\n\n" "\033[2B${RED}No option was selected${RESET} (user hit Cancel or unselected all options)"
    else
        for step_sel in ${steps_sel}; do
            case "${step_sel}" in
            1 )
                start_step
                ;;
            2 )
                header_step
                ;;
            3 )
                init_step
                ;;
            4 )
                uninstall_step
                ;;
            5 )
                update_step
                ;;
            6 )
                install_step
                ;;
            7 )
                configuration_step
                ;;
            8 )
                end_step
                ;;
            9 )
                all_steps
                ;;
            *)
                printf "%s\n" "Unsupported item ${step_sel} !" >&2
                exit 1
                ;;
            esac
        done
    fi
}

step() {
    local -r function=$1
    local -r message=$2
    local dash_line=""

    for (( i=0; i<${#message}; i++ )); do
        dash_line+="-" ; 
    done

    printf "\n%s\n%s\n\n" "${YELLOW}${message}" "${dash_line}${RESET}"

    ${function}
}

display_step() {
    local -r message="$1"
    local -r width="$(( $(tput cols) / 2 ))"
    clear_noclear

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