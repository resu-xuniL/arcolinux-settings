export RESET=$(tput sgr0)
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export BLUE=$(tput setaf 4)
export PURPLE=$(tput setaf 5)

export INSTALL_DIRECTORY=$(dirname $(readlink -f $(basename `pwd`)))/assets
export CURRENT_USER=$(whoami)
export CURRENT_RESOLUTION=$(xdpyinfo | grep dimensions: | awk '{print $2}')
export VM=$(systemd-detect-virt)

function init() {
    exec_log "find $INSTALL_DIRECTORY -type f -exec chmod 644 -- {} +" "${GREEN}[+]${RESET} Changing permissions on [${YELLOW}configuration${RESET}] files"
    exec_log "sed -i \"s/Noto Sans 11/Ubuntu 9/\" ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml" "${GREEN}[+]${RESET} Changing [${YELLOW}FONT${RESET}]"
    exec_log "sed -i \"s/Monospace 11/Monospace 9/\" ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml" "${GREEN}[+]${RESET} Changing [${YELLOW}FONT${RESET}] size"
    if [[ ! ${CURRENT_USER} = "wam" ]];then
	    exec_log "sudo usermod -aG vboxsf ${USER}" "${GREEN}[+]${RESET} Giving permission for [${YELLOW}VM shared folder${RESET}] (guest machine)"
    fi
    check_dir ${HOME}/.config "user"
    check_dir ${HOME}/Documents/[Nextcloud] "user"
    sleep 2
}

function usage() {
    echo "Usage : ./XXXXXXXXXX.sh [OPTION]"
    echo "Options :"
    echo "  -h --help    : Display this help."
    echo "  -v --verbose : Verbose mode."
    echo "  --no-reboot  : Do not reboot the system at the end of the script."
}

VALID_ARGS=$(getopt -o hv --long help,verbose,no-reboot -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
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
    echo -e "\n${GREEN}[OK]${RESET} Root privileges granted"
else
    clear
    echo -e "\n${RED}[KO]${RESET} Root privileges denied"
    exit 1
fi

function check_internet() {
    local -r tool='curl'
    local -r tool_opts='-s --connect-timeout 8'

    if ! ${tool} ${tool_opts} https://archlinux.org/ >/dev/null 2>&1; then
        log_msg "\n${RED}[KO]${RESET} Error -> No internet connection${RESET}"
        return 1
    else
        log_msg "\n${GREEN}[OK]${RESET} Internet connection detected${RESET}"
        sleep 2
    fi

    return 0
}

function init_log() {
    if [[ -f "${LOG_FILE}" ]]; then
        rm -f "${LOG_FILE}"
    fi

    touch "${LOG_FILE}"
    echo -e "Commit hash: $(git rev-parse HEAD)" >>"${LOG_FILE}"
    echo -e "Log file: ${LOGFILE}\n" >>"${LOG_FILE}"
    log_msg "\n${GREEN}[OK]${RESET} Log file created${RESET}"

    sleep 2
}