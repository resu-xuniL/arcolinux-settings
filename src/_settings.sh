declare -A sys_config_list

selected_packages=""

function set_config_list() {

    sys_config_list=(
        [Adjust clock for dual-boot]="timedatectl[]set-local-rtc[]1[]--adjust-system-clock"
        [Set filenames order]="localectl[]set-locale[]LC_COLLATE=C"
        [Enable pacman cache cleanup]="systemctl[]enable[]--now[]paccache.timer"
    )
}

function config_settings() {
    export action_type="config_system"

    set_config_list

    select_from_list sys_config_list "Set system Configuration"

    local -r packages="${selected_packages}"

    selected_packages=""

    manage_lst "${packages}"
    
    ################################################################
    ##########      Set settings for filenames order      ##########
    ################################################################

    if [[ "${packages}" =~ "localectl[]set-locale[]LC_COLLATE=C" ]];then
        exec_log "gsettings set org.gtk.Settings.FileChooser sort-directories-first true" "${GREEN}[+]${RESET} Settings [${YELLOW}GTK FileChooser${RESET}] sort-directories-first : [${YELLOW}True${RESET}]"
    fi
}
