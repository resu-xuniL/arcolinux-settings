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
    clear
    cat <<-EOF
${YELLOW}################################################################
 
                        ${message}            
                                                   
################################################################${RESET}
EOF
}

prompt_to_continue() {
    printf "%b" "\n${BLUE}:: ${RESET}Press [${GREEN}Enter${RESET}] to continue, or [${RED}Ctrl+C${RESET}] to cancel."

    read -rp "" choice
    [[ -n $choice ]] && exit 0
}

prompt_default_no() {
    printf "%b" "\n$1"
    yes="y"
    no="n"
    read -rp " ($yes/${no^^}) : " choice

    if [ "${choice,,}" == "$yes" ]; then
        return 0
    else
        return 1
    fi
}

prompt_default_yes() {
    printf "%b" "\n$1"
    yes="y"
    no="n"
    read -rp " (${yes^^}/$no) : " choice

    if [ "${choice,,}" == "$no" ]; then
        return 1
    else
        return 0
    fi
}

exit_status() {
    local exit_status=$?

    printf "%s\n" "[INFO]: Exit status: ${exit_status}" >>"${LOG_FILE}"
    if [[ ${exit_status} -ne 0 ]]; then
        if [[ ${action_type} == "uninstall" ]]; then
            log_msg "${GREEN}${package} is not installed${RESET}"
        elif [[ ${action_type} == "install" ]]; then
            log_msg "${RED}Error: ${package} installation failed${RESET}"
        else
            log_msg "${RED}Error: something went wrong${RESET}"
        fi
    else
        if   [[ ${action_type} == "uninstall" && ("${package}" =~ "broadcom-wl-dkms" || "${package}" =~ "rtl8821cu-morrownr-dkms-git") ]]; then
            ((mkinitcpio_needed++))
        fi
        #printf "%s\n" "${GREEN}Complete: ${package} installation succeeded${RESET}"
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
        eval "${command}" >>"${LOG_FILE}" 2>&1
    fi

    exit_status
}

exec_log() {
    local -r command="$1"
    local -r comment="$2"
    
    log_msg "${comment}"
    execute "${command}"
}
