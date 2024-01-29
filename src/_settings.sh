declare -A sys_config_list

selected_packages=""

function set_config_list() {

    sys_config_list=(
        [Adjust clock for dual-boot]="timedatectl[]set-local-rtc[]1[]--adjust-system-clock"
        [Set filenames order]="localectl[]set-locale[]LC_COLLATE=C"
        [Enable pacman cache cleanup]="systemctl[]enable[]--now[]paccache.timer"
        [Audio : set speakers volume to 100%]="amixer[]set[]Master[]100%"
    )
}

function config_settings() {
    local MICROPHONE_STATE=$(amixer get Capture | grep -E '\[o.+\]')
    action_type="config_system"

    set_config_list

    select_from_list sys_config_list "Set system Configuration"

    local -r packages="${selected_packages}"

    selected_packages=""

    manage_lst "${packages}"
    
    ################################################################
    ##########             Set filename order             ##########
    ################################################################

    if [[ "${packages}" =~ "localectl[]set-locale[]LC_COLLATE=C" ]];then
        exec_log "gsettings set org.gtk.Settings.FileChooser sort-directories-first true" "${GREEN}[+]${RESET} Setting [${YELLOW}GTK FileChooser${RESET}] sort-directories-first : [${YELLOW}True${RESET}]"
    fi

    ################################################################
    ##########         Audio : set microphone off         ##########
    ################################################################

    if [[ "${packages}" =~ "amixer[]set[]Master[]100%" && $MICROPHONE_STATE =~ '[on]' ]];then
        exec_log "amixer set Capture 0%" "${GREEN}[+]${RESET} Setting [${YELLOW}microphone${RESET}] volume to : [${YELLOW}0%${RESET}]"
        exec_log "amixer set Capture toggle" "${GREEN}[+]${RESET} Toggling [${YELLOW}microphone${RESET}] to : [${YELLOW}MUTE${RESET}]"
    fi
}
