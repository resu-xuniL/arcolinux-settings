arch_copy_files() {
    exec_log "sudo cp ${INSTALL_DIRECTORY}/_archlinux/locale.conf /etc" "${GREEN}[+]${RESET} Copying [${YELLOW}locale.conf${RESET}] file to [${YELLOW}/etc${RESET}] folder"
    exec_log "sudo cp ${INSTALL_DIRECTORY}/_archlinux/environment /etc" "${GREEN}[+]${RESET} Copying [${YELLOW}environment${RESET}] file to [${YELLOW}/etc${RESET}] folder"
    exec_log "sudo cp ${INSTALL_DIRECTORY}/_archlinux/pacman.conf /etc" "${GREEN}[+]${RESET} Copying [${YELLOW}pacman.conf${RESET}] file to [${YELLOW}/etc${RESET}] folder"
    exec_log "sudo cp ${INSTALL_DIRECTORY}/_archlinux/arcolinux-mirrorlist /etc/pacman.d" "${GREEN}[+]${RESET} Copying [${YELLOW}arcolinux-mirrorlist${RESET}] file to [${YELLOW}/etc/pacman.d${RESET}] folder"
    exec_log "sudo cp ${INSTALL_DIRECTORY}/_archlinux/mirrorlist /etc/pacman.d" "${GREEN}[+]${RESET} Copying [${YELLOW}mirrorlist${RESET}] file to [${YELLOW}/etc/pacman.d${RESET}] folder"

    exec_log "cp ${INSTALL_DIRECTORY}/_archlinux/.face ${HOME}" "${GREEN}[+]${RESET} Copying [${YELLOW}icon${RESET}] file to [${YELLOW}${HOME}${RESET}]"

    exec_log "sudo pacman-key --recv-keys 74F5DE85A506BF64" "${GREEN}[+]${RESET} Importing [${YELLOW}public keys${RESET}] for [${YELLOW}Arcolinux repo${RESET}] packages"
    exec_log "sudo pacman-key --lsign-key 74F5DE85A506BF64" "${GREEN}[+]${RESET} Updating [${YELLOW}trust database keys${RESET}]"

    exec_log "sudo pacman -Syyu --noconfirm" "${GREEN}[+]${RESET} Updating full system ${RED}(might be long)${RESET}"
}

arch_config_files(){
    action_type="config_files"

    file_conf="X11-keymap"
    exec_log "sudo localectl --no-convert set-x11-keymap fr pc104 ,oss" "${GREEN}[+]${RESET} Setting [${YELLOW}x11-keymap${RESET}] to [${YELLOW}fr${RESET}]"

    file_conf="SDDM"
    exec_log "sudo systemctl enable sddm" "${GREEN}[+]${RESET} Enabling [${YELLOW}SDDM${RESET}]"

    file_conf="Locate"
    exec_log "sudo updatedb" "${GREEN}[+]${RESET} Updating [${YELLOW}locate${RESET}] database"

    file_conf="vconsole.conf"
    exec_log "printf '%s\n' 'FONT=gr737c-8x16' | sudo tee -a /etc/vconsole.conf" "${GREEN}[+]${RESET} Adding [${YELLOW}FONT${RESET}] to [${YELLOW}vconsole.conf${RESET}] file"

    file_conf="XFCE Terminal"
    exec_log "xfconf-query -c xfce4-terminal -p /scrolling-bar -n -t string -s TERMINAL_SCROLLBAR_NONE" "${GREEN}[+]${RESET} XFCE terminal : creating property [${YELLOW}SCROLLING BAR${RESET}] and setting it to [${YELLOW}NONE${RESET}]"
    exec_log "xfconf-query -c xfce4-terminal -p /misc-default-geometry -n -t string -s 120x30" "${GREEN}[+]${RESET} XFCE terminal : creating property [${YELLOW}DEFAULT GEOMETRY${RESET}] and setting it to [${YELLOW}120x30${RESET}]"
    exec_log "xfconf-query -c xfce4-session -p /general/SaveOnExit -n -t bool -s false" "${GREEN}[+]${RESET} XFCE session : creating property [${YELLOW}SAVE ON EXIT${RESET}] and setting it to [${YELLOW}FALSE${RESET}]"

    file_conf="XFCE Desktop"
    exec_log "xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -n -t bool -s false" "${GREEN}[+]${RESET} XFCE desktop : creating property [${YELLOW}SHOW FILESYSTEM${RESET}] icon to [${YELLOW}FALSE${RESET}]"
    exec_log "xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -n -t bool -s false" "${GREEN}[+]${RESET} XFCE desktop : creating property [${YELLOW}SHOW HOME${RESET}] icon to [${YELLOW}FALSE${RESET}]"
    exec_log "xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -n -t bool -s false" "${GREEN}[+]${RESET} XFCE desktop : creating property [${YELLOW}SHOW REMOVABLE${RESET}] icon to [${YELLOW}FALSE${RESET}]"
    exec_log "xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -n -t bool -s false" "${GREEN}[+]${RESET} XFCE desktop : creating property [${YELLOW}SHOW TRASH${RESET}] icon to [${YELLOW}FALSE${RESET}]"
    
    file_conf="Virtualbox guest utils"
    if pacman -Q virtualbox-guest-utils &> /dev/null; then
        exec_log "sudo usermod -aG vboxsf ${USER}" "${GREEN}[+]${RESET} Giving permission for [${YELLOW}VM shared folder${RESET}] (guest machine)"
    fi
}

arch_preset_step(){
    if [[ ${CURRENT_OS} == "Arch Linux" ]]; then
        if [[ -z ${XDG_CURRENT_DESKTOP} ]]; then
            display_step "ARCH PRESET MODE"
            sleep 1
            step arch_copy_files "Copy files"
            prompt_to_continue
            step arch_required "Install deps"
            prompt_to_continue
            step arch_config_files "Config files"
            prompt_to_continue
        else
            log_msg "${RED}/!\ [${RESET}${BB}${YELLOW}ARCH LINUX${RESET}${RED}] is now set and ready to be riced. Run [${RESET}${BB}${YELLOW}'settings.sh' WITHOUT '--preset' option${RESET}${RED}] ! /!\ ${RESET}\n"
            exit 0
        fi
    else
        log_msg "\n${RED}/!\ THIS IS NOT AN [${RESET}${BB}${YELLOW}ARCH LINUX${RESET}${RED}] DISTRO /!\ ${RESET}\n"
        restore_xfce_terminal_display
        exit 0
    fi
}
