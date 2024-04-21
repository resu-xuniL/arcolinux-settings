declare -A sys_config_list

selected_packages=""

set_config_list() {

    sys_config_list=(
        [Adjust clock for dual-boot]="timedatectl set-local-rtc 1 --adjust-system-clock"
        [Set filenames order]="localectl set-locale LC_COLLATE=C"
        [Enable pacman cache cleanup]="systemctl enable --now paccache.timer"
    )
}

config_settings() {
    local microphone_state=$(amixer get Capture | grep -E '\[o.+\]')
    action_type="config_system"

    set_config_list

    select_from_list sys_config_list "Set system Configuration"

    local -r packages="${selected_packages}"

    selected_packages=""

    manage_lst "${packages}"

    extra_config_settings
}

extra_config_settings() {
    ################################################################
    ##########                   Audio                    ##########
    ##############  Set volume 100 % & microphone off ##############        
    ################################################################

    exec_log "amixer set Master 100%" "${GREEN}[+]${RESET} Setting [${YELLOW}speakers${RESET}] volume to : [${YELLOW}100%${RESET}]"
    exec_log "amixer set Capture 0%" "${GREEN}[+]${RESET} Setting [${YELLOW}microphone${RESET}] volume to : [${YELLOW}0%${RESET}]"
    exec_log "amixer set Capture toggle" "${GREEN}[+]${RESET} Toggling [${YELLOW}microphone${RESET}] to : [${YELLOW}MUTE${RESET}]"

    ################################################################
    ##########                 Sync time                  ##########
    ################################################################

    exec_log "sudo timedatectl set-ntp true" "${GREEN}[+]${RESET} Enabling and starting [${YELLOW}Sync time${RESET}]"

    ################################################################
    ##########             Set filename order             ##########
    ################################################################

    if [[ ${packages} =~ "localectl set-locale LC_COLLATE=C" ]]; then
        exec_log "gsettings set org.gtk.Settings.FileChooser sort-directories-first true" "${GREEN}[+]${RESET} Setting [${YELLOW}GTK FileChooser${RESET}] sort-directories-first : [${YELLOW}True${RESET}]"
    fi
}
