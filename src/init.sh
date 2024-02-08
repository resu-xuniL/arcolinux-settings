export RESET=$(tput sgr0)
export BLINK=$(tput blink)
export BOLD=$(tput bold)
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export BLUE=$(tput setaf 4)
export PURPLE=$(tput setaf 5)

export INSTALL_DIRECTORY=$(dirname $(readlink -f $(basename `pwd`)))/assets
export CURRENT_USER=$(whoami)
export CURRENT_RESOLUTION=$(xdpyinfo | grep dimensions: | awk '{print $2}')
export VM=$(systemd-detect-virt)

change_xfce_terminal_display() {
    exec_log "xfconf-query -c xfce4-terminal -p /background-darkness -s 1" "${GREEN}[+]${RESET} XFCE terminal : Setting [${YELLOW}BACKGROUND DARKNESS${RESET}] to [${YELLOW}1${RESET}]"
    exec_log "xfconf-query -c xfce4-terminal -p /font-use-system -s false" "${GREEN}[+]${RESET} XFCE terminal : Setting use of system [${YELLOW}FONT${RESET}] to [${YELLOW}FALSE${RESET}]"
    exec_log "xfconf-query -c xfce4-terminal -p /font-name -s Ubuntu\ Mono\ Bold\ 9" "${GREEN}[+]${RESET} XFCE terminal : Changing [${YELLOW}FONT${RESET}] name & size"

    sleep 2
}

check_internet() {
    local -r tool='curl'
    local -r tool_opts='-s --connect-timeout 8'

    if ! ${tool} ${tool_opts} https://archlinux.org/ >/dev/null 2>&1; then
        log_msg "${RED}[KO] Error : No internet connection !${RESET}\n"
        return 1
    else
        log_msg "${GREEN}[OK]${RESET} Internet connection detected\n"
    fi

    return 0
}

init() {
    init_log
    exec_log "find $INSTALL_DIRECTORY -type f -exec chmod 644 -- {} +" "${GREEN}[+]${RESET} Changing permissions on [${YELLOW}configuration${RESET}] files"
 
    if [[ ! ${CURRENT_USER} == "wam" ]];then
	    exec_log "sudo usermod -aG vboxsf ${USER}" "${GREEN}[+]${RESET} Giving permission for [${YELLOW}VM shared folder${RESET}] (guest machine)"
    fi
    check_dir ${HOME}/.config "user"
    check_dir ${HOME}/Documents/[Nextcloud] "user"
}

init_log() {
    local -r commit_hash=$(git rev-parse HEAD 2>&1)
    
    if [[ -f "${LOG_FILE}" ]]; then
        rm -f "${LOG_FILE}"
    fi

    touch "${LOG_FILE}"
    printf "%s\n" "Commit SHA1 hash: ${commit_hash}" >>"${LOG_FILE}"
    printf "%s\n\n" "Log file: ${LOG_FILE}" >>"${LOG_FILE}"
    log_msg "${GREEN}[+]${RESET} Log file created${RESET}"
}

usage() {
    printf "%s\n" "Usage : ./install.sh [OPTION]"
    printf "%s\n" "Options :"
    printf "%s\n" "  -h --help    : Display this help."
    printf "%s\n" "  -v --verbose : Verbose mode."
    printf "%s\n" "  --no-reboot  : Do not reboot the system at the end of the script."
}

valid_args=$(getopt -o hv --long help,verbose,no-reboot -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$valid_args"
while [ : ]; do
  case "$1" in
    -h | --help)
        usage
        exit 1
        ;;
    -v | --verbose)
        export VERBOSE=true
        shift
        ;;
    --no-reboot)
        export NOREBOOT=true
        shift
        ;;
    --) shift; 
        break 
        ;;
  esac
done

if [[ -z ${VERBOSE+x} ]]; then
    export VERBOSE=false
fi

if [[ -z ${NOREBOOT+x} ]]; then
    export NOREBOOT=false
fi

if sudo -v; then
    clear
    printf "\n%s\n" "${GREEN}[OK]${RESET} Root privileges granted"
else
    clear
    printf "\n%s\n" "${RED}[KO]${RESET} Root privileges denied"
    exit 1
fi
