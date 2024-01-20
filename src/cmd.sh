function step() {
    local -r function=$1
    local -r message=$2

    echo -e "\n${YELLOW}${message}${RESET}"

    ${function}
}

function display_step() {
    local -r message="$1"
    clear
    cat <<-EOF
${YELLOW}################################################################
 
                        ${message}            
                                                   
################################################################${RESET}
EOF
}

function ask_question() {
    yes="y"
    no="n"
    read -rp "$1 ($yes/${no^^}) : " choice

    if [ "${choice,,}" == "$yes" ]; then
        return 0
    else
        return 1
    fi
}

function ask_question_confirm() {
    yes="y"
    no="n"
    read -rp "$1 (${yes^^}/$no) : " choice

    if [ "${choice,,}" == "$no" ]; then
        return 1
    else
        return 0
    fi
}

function exit_status() {
    local exit_status=$?

    echo "[INFO]: Exit status: ${exit_status}" >>"${LOG_FILE}"
    if [[ ${exit_status} -ne 0 ]]; then
        if [[ ${action_type} == "uninstall" ]]; then
            echo -e "${GREEN}${package} is not installed${RESET}"
        elif [[ ${action_type} == "install" ]]; then
            echo -e "${RED}Error: ${package} installation failed${RESET}"
        else
            echo -e "${RED}Error: something went wrong${RESET}"
        fi
    #else
        #echo -e "${GREEN}Complete: ${package} installation succeeded${RESET}"
    fi
}

function log() {
    local -r comment="$1"

    echo "[$(date "+%Y-%m-%d %H:%M:%S")] ${comment}" >>"${LOG_FILE}"
}

function log_msg() {
    local -r comment="$1"

    echo -e "${comment}"
    log "${comment}"
}

function exec() {
    local -r command="$1"

    if [[ ${VERBOSE} == true ]]; then
        eval "${command}" 2>&1 | tee -a "${LOG_FILE}"
    else
        eval "${command}" >>"${LOG_FILE}" 2>&1
    fi

    exit_status
}

function exec_log() {
    local -r command="$1"
    local -r comment="$2"
    
    log_msg "${comment}"
    exec "${command}"
}
