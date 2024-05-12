export RESET=$(tput sgr0)
export BLINK=$(tput blink)
export BOLD=$(tput bold)
export BB=$(tput blink; tput bold)
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export BLUE=$(tput setaf 4)
export PURPLE=$(tput setaf 5)

export NEWT_COLORS='
    root=white,black
    shadow=black,gray
    title=black,lightgray
    button=white,black
    checkbox=black,lightgray
    entry=black,lightgray
    emptyscale=,gray
    fullscale=,cyan
    actcheckbox=lightgray,cyan
'
export INSTALL_DIRECTORY=$(dirname $(readlink -f $(basename `pwd`)))/assets
export CURRENT_USER=$(whoami)
export CURRENT_RESOLUTION=$(xdpyinfo | grep dimensions: | awk '{print $2}')
export CURRENT_OS=$(cat /etc/os-release | grep NAME | cut -d '=' -f 2 | uniq | tr -d \")
export VM=$(systemd-detect-virt)
export PASSWORD=""

change_xfce_terminal_display() {
    if [[ $(xfconf-query -c xfce4-terminal -l | grep -c background-darkness) -eq 0 ]]; then
        exec_log "xfconf-query -c xfce4-terminal -p /background-darkness -n -t double -s 1" "${GREEN}[+]${RESET} XFCE terminal : Creating property [${YELLOW}BACKGROUND DARKNESS${RESET}] and setting it at [${YELLOW}1${RESET}]"
    else
        exec_log "xfconf-query -c xfce4-terminal -p /background-darkness -s 1" "${GREEN}[+]${RESET} XFCE terminal : Setting [${YELLOW}BACKGROUND DARKNESS${RESET}] to [${YELLOW}1${RESET}]"
    fi

    if [[ $(xfconf-query -c xfce4-terminal -l | grep -c misc-default-geometry) -eq 0 ]]; then
        exec_log "xfconf-query -c xfce4-terminal -p /misc-default-geometry -n -t string -s 100x30" "${GREEN}[+]${RESET} XFCE terminal : Creating property [${YELLOW}DEFAULT GEOMETRY${RESET}] and setting it at [${YELLOW}100x30${RESET}]"
    fi

    if [[ $(xfconf-query -c xfce4-terminal -l | grep -c scrolling-bar) -eq 0 ]]; then
        exec_log "xfconf-query -c xfce4-terminal -p /scrolling-bar -n -t string -s TERMINAL_SCROLLBAR_NONE" "${GREEN}[+]${RESET} XFCE terminal : Creating property [${YELLOW}SCROLLING BAR${RESET}] and setting it at [${YELLOW}NONE${RESET}]"
    fi

    if [[ $(fc-list : family  | grep Ubuntu) ]]; then
        if [[ $(xfconf-query -c xfce4-terminal -l | grep -c font-use-system) -eq 0 ]]; then
            exec_log "xfconf-query -c xfce4-terminal -p /font-use-system -n -t bool -s false" "${GREEN}[+]${RESET} XFCE terminal : Creating property [${YELLOW}USE SYSTEM FONT${RESET}] and setting it at [${YELLOW}FALSE${RESET}]"
        else
            exec_log "xfconf-query -c xfce4-terminal -p /font-use-system -s false" "${GREEN}[+]${RESET} XFCE terminal : Setting [${YELLOW}USE SYSTEM FONT${RESET}] to [${YELLOW}FALSE${RESET}]"
        fi

        if [[ $(xfconf-query -c xfce4-terminal -l | grep -c font-name) -eq 0 ]]; then
            exec_log "xfconf-query -c xfce4-terminal -p /font-name -n -t string -s Ubuntu\ Mono\ Bold\ 9" "${GREEN}[+]${RESET} XFCE terminal : Creating property [${YELLOW}FONT-NAME${RESET}] and setting it at [${YELLOW}Ubuntu Mono Bold 9${RESET}]"
        else
            exec_log "xfconf-query -c xfce4-terminal -p /font-name -s Ubuntu\ Mono\ Bold\ 9" "${GREEN}[+]${RESET} XFCE terminal : Changing [${YELLOW}FONT-NAME${RESET}] for [${YELLOW}Ubuntu Mono Bold 9${RESET}]"
        fi
    fi

    sleep 2
}

restore_xfce_terminal_display() {
    if [[ $(xfconf-query -c xfce4-terminal -l | grep -c background-darkness) -gt 0 ]]; then
        exec_log "xfconf-query -c xfce4-terminal -p /background-darkness -s 0.85" "${GREEN}[+]${RESET} XFCE terminal : Restoring [${YELLOW}BACKGROUND DARKNESS${RESET}] to [${YELLOW}0.85${RESET}]"
        exec_log "xfconf-query -c xfce4-terminal -p /font-use-system -s true" "${GREEN}[+]${RESET} XFCE terminal : Restoring [${YELLOW}USE SYSTEM FONT${RESET}] to [${YELLOW}TRUE${RESET}]"
    fi

    if [[ ${NOLOG} == "true" ]]; then
        rm ${LOG_FILE}; printf "%s %b\n" "${RED}[-]${RESET} Deleting log file" "${GREEN}\u2713${RESET}"
    fi
}

clear_noclear() {
    if [[ ${NOCLEAR} == false ]]; then
        clear
    fi
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

    exec_log "find ${INSTALL_DIRECTORY} -type f -exec chmod u+w,a+r {} +" "${GREEN}[+]${RESET} Setting permissions on [${YELLOW}configuration${RESET}] files"

    if [[ ! ${VM} == "none" ]]; then
	    exec_log "sudo usermod -aG vboxsf ${USER}" "${GREEN}[+]${RESET} Giving permission for [${YELLOW}VM shared folder${RESET}] (guest machine)"
    else
        wam_scripts
    fi

    if [[ -n ${XDG_CURRENT_DESKTOP} ]]; then
        prompt_choice "${BLUE}:: ${RESET}Do you want to check for useless kernels ?" true
        if [[ ${answer} == true ]]; then
            remove_useless_kernels
        fi

        prompt_choice "${BLUE}:: ${RESET}Do you want to check for required dependencies ?" true
        if [[ ${answer} == true ]]; then
            check_required_dep
        fi
    fi
}

init_log() {
    local -r commit_hash=$(git rev-parse HEAD 2>&1)

    if [[ -f "${LOG_FILE}" ]]; then
        rm -f "${LOG_FILE}"
    fi

    touch "${LOG_FILE}"
    printf "%s\n" "Commit SHA1 hash: ${commit_hash}" >>"${LOG_FILE}"
    printf "%s\n\n" "Log file: ${LOG_FILE}" >>"${LOG_FILE}"
    log_msg "${GREEN}[+]${RESET} Log file tagged${RESET} ${GREEN}\u2713${RESET}"
}

usage() {
    printf "\n%s\n" "Usage : ./run.sh [OPTION(s)]"
    printf "\n%s\n" "Options :"
    printf "%s\n" "  -h --help      : Display this help."
    printf "%s\n" "  -t --test      : Test mode."
    printf "%s\n" "  -g --gui       : Test mode with GUI selection."
    printf "%s\n" "  -f --force     : Force extra-installation."
    printf "%s\n" "  -i --install   : Install step only"
    printf "%s\n" "  -u --uninstall : Uninstall step only"
    printf "%s\n" "  -c --config    : configuration step only"
    printf "%s\n" "  -v --verbose   : Verbose mode."
    printf "%s\n" "  -n --no-log    : Delete log file."
    printf "%s\n" "  --no-clear     : Do not clear display between steps"
    printf "%s\n" "  --no-reboot    : Do not reboot the system at the end of the script."
}

valid_args=$(getopt -o htgfiucnv --long help,test,gui,force,install,uninstall,config,verbose,no-log,no-clear,no-reboot -- "$@")
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
    -t | --test)
        export TESTMODE=true
        export NOREBOOT=true
        shift
        ;;
    -g | --gui)
        export GUIMODE=true
        export NOREBOOT=true
        shift
        ;;
    -f | --force)
        export FORCEMODE=true
        shift
        ;;
    -i | --install)
        export INSTALLMODE=true
        shift
        ;;
    -u | --uninstall)
        export UNINSTALLMODE=true
        shift
        ;;
    -c | --config)
        export CONFIGMODE=true
        shift
        ;;
    -v | --verbose)
        export VERBOSE=true
        shift
        ;;
    -n | --no-log)
        export NOLOG=true
        shift
        ;;
    --no-clear)
        export NOCLEAR=true
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

if [[ -z ${TESTMODE+x} ]]; then
    export TESTMODE=false
fi

if [[ -z ${GUIMODE+x} ]]; then
    export GUIMODE=false
fi

if [[ -z ${FORCEMODE+x} ]]; then
    export FORCEMODE=false
fi

if [[ -z ${INSTALLMODE+x} ]]; then
    export INSTALLMODE=false
fi

if [[ -z ${UNINSTALLMODE+x} ]]; then
    export UNINSTALLMODE=false
fi

if [[ -z ${CONFIGMODE+x} ]]; then
    export CONFIGMODE=false
fi

if [[ -z ${VERBOSE+x} ]]; then
    export VERBOSE=false
fi

if [[ -z ${NOLOG+x} ]]; then
    export NOLOG=false
fi

if [[ -z ${NOCLEAR+x} ]]; then
    export NOCLEAR=false
fi
if [[ -z ${NOREBOOT+x} ]]; then
    export NOREBOOT=false
fi

if sudo -v; then
    clear_noclear
    printf "\n%s\n" "${GREEN}[OK]${RESET} Root privileges granted"
else
    clear_noclear
    printf "\n%s\n" "${RED}[KO]${RESET} Root privileges denied"
    exit 1
fi
