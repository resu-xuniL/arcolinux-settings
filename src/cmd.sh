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

center_text() {
    local -r message="$1"
    local -r width=$2
    #local -r padding=$(printf '%0.1s' \ {1..25}) #25 --> 100
    
    for i in $(seq 1 ${width}); do
        local padding+=$(printf "%0.1s" " ");
    done
    printf "\n%0.*s %s %0.*s\n" "$(( (${width} - ${#message} - 2) /2 ))" "${padding}" "${message}" "$(( (${width} - ${#message} - 1) /2 ))" "${padding}"   
}

prompt_to_continue() {
    printf "%b" "\n${BLUE}:: ${RESET}Press [${GREEN}Enter${RESET}] to continue, or [${RED}Ctrl+C${RESET}] to cancel."

    read -rp "" choice
    [[ -n $choice ]] && exit 0
}

prompt_choice() {
    local -r question=$1
    local default=$2

    if [[ ${default} == true ]]; then
        options="[Y/n] : "
        default="y"
    else
        options="[y/N] : "
        default="n"
    fi

    while [ : ]; do
        printf "\n"
        read -p "${question} ${options}" -n 1 -s -r input
        input=${input:-${default}}
        printf "%s\n\n" ${input}

        case ${input} in
        [yY] )  answer=true;
                break
                ;;
        [nN] )  answer=false;
                break
                ;;
        * )     printf "%s\n" "${RED}Invalid selection${RESET}"
                ;;
        esac
    done
}

exit_status() {
    local exit_status=$?
    local -r comment="$1"
    
    printf "%s\n" "[INFO]: Exit status: ${exit_status}" >>"${LOG_FILE}"
    if [[ ${exit_status} -ne 0 ]]; then
        if [[ ${action_type} == "install" ]]; then
            log_msg "${RED}${BOLD}[KO]: ${package} installation failed${RESET}"
        elif [[ ${action_type} == "config_apps" ]]; then
            log_msg "${RED}${BOLD}[KO]: Something went wrong on${RESET} [${YELLOW}${app_conf}${RESET}] ${RED}configuration${RESET}"
        elif [[ ${action_type} == "config_files" ]]; then
            log_msg "${RED}${BOLD}[KO]: Something went wrong on${RESET} [${YELLOW}${file_conf}${RESET}] ${RED}configuration${RESET}"
        else
            log_msg "${RED}${BOLD}[KO]: something went wrong${RESET}"
        fi
    else
        printf "%b\n" "\033[1A\033[2K${comment} ${GREEN}\u2713${RESET}"
        
        if   [[ ${action_type} == "uninstall" ]]; then
            case ${package} in
                rtl8821cu-morrownr-dkms-git )
                    ((mkinitcpio_needed++));
                    ;;
                broadcom-wl-dkms )
                    mkinitcpio_needed=0;
                    ;;
            esac
        fi
    fi
}

log() {
    local -r comment="$1"

    printf "%s\n" "[$(date "+%Y-%m-%d %H:%M:%S")] ${comment}" >>"${LOG_FILE}"
}

log_msg() {
    local -r comment="$1"

    printf "%b\n" "${comment}"
    log "${comment}"
}

execute() {
    local -r command="$1"

    if [[ ${VERBOSE} == true ]]; then
        eval "${command}" 2>&1 | tee -a "${LOG_FILE}"
    else
        eval "${command}" >>"${LOG_FILE}" 2>&1 &
    fi
    job_pid=$!
    
    progress_dots
    exit_status "${comment}"
}

exec_log() {
    local -r command="$1"
    local -r comment="$2"
    
    log_msg "${comment}"
    execute "${command}"
}

progress_dots() {
    local dots="....."

    while kill -0 $job_pid 2> /dev/null; do
        printf "%b [     ]%b\n" "\033[1A${comment}" "\033[6D${BOLD}${GREEN}${dots}${RESET}"
        sleep 0.5
        dots+="."
        if [[ ${dots} == "......" ]]; then
            dots=""
        fi   
    done  
}