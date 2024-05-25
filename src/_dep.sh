arch_required() {
    declare -a required_arch_list

    required_arch_list=(
        mesa # need to be installed first
        alsa-utils
        base-devel
        bc
        bibata-cursor-theme-bin
        jq
        libadwaita-without-adwaita-git
        locate
        man
        most
        network-manager-applet
        noto-fonts
        os-prober
        pacman-contrib
        pavucontrol
        pulseaudio
        pulseaudio-alsa
        rsync
        sddm
        thunar-archive-plugin
        ttf-ubuntu-font-family
        wget
        xdg-user-dirs
        xfce4
        xfce4-pulseaudio-plugin
        xfce4-screenshooter
        xfce4-whiskermenu-plugin
        xorg-xdpyinfo
        yay
    )

    if [[ ${VM} == "none" ]]; then
        required_arch_list+=(linux-firmware)
    else
        required_arch_list+=(virtualbox-guest-utils)
    fi

    log_msg "${BLUE}:: ${RESET}Installing required packages for [${YELLOW}ARCH LINUX${RESET}] :"

    for required_arch_dep in "${required_arch_list[@]}"; do
        if [[ ${required_arch_dep} == "virtualbox-guest-utils" ]]; then
            if pacman -Q virtualbox-guest-utils-nox &> /dev/null; then
                action_type="uninstall"
                manage_one "virtualbox-guest-utils-nox"
            fi
        fi
        required_arch_deps+="${required_arch_dep}&"
    done

    action_type="install"
    manage_lst "${required_arch_deps}"
    
    log_msg "${BLUE}:: ${RESET}Configuring installed packages :"

    if pacman -Q virtualbox-guest-utils &> /dev/null; then
        exec_log "sudo usermod -aG vboxsf ${USER}" "${GREEN}[+]${RESET} Giving permission for [${YELLOW}VM shared folder${RESET}] (guest machine)"
    fi
    exec_log "sudo fc-cache -fv" "${GREEN}[+]${RESET} Building [${YELLOW}fonts${RESET}] cache file"
}

remove_useless_kernels() {
    declare -a kernel_to_remove_list

    kernel_to_remove_list=(
    linux-lts-headers
    linux-lts
    linux-zen-headers
    linux-zen
    linux-hardened-headers
    linux-hardened
    linux-rt-headers
    linux-rt
    linux-rt-lts-headers
    linux-rt-lts
    linux-cachyos-headers
    linux-cachyos
    linux-xanmod-headers
    linux-xanmod
    )

    log_msg "${GREEN}[+]${RESET} Checking kernel(s) to remove :"

    for kernel in "${kernel_to_remove_list[@]}"; do
        kernels+="${kernel}&"
    done

    action_type="uninstall"
    manage_lst "${kernels}"
}

check_required_dep() {
    declare -a required_dep_list

    required_dep_list=(
        ffmpegthumbnailer
        file-roller
        gvfs
        gvfs-afc
        gvfs-mtp
        gvfs-nfs
        gvfs-smb
        p7zip
        tldr
    )

    if [[ ! ${VM} == "none" ]]; then
        required_dep_list+=(virtualbox-guest-utils)
    fi

    log_msg "${GREEN}[+]${RESET} Checking required packages :"

    for required_dep in "${required_dep_list[@]}"; do
        if [[ ${required_dep} == "virtualbox-guest-utils" ]]; then
            if pacman -Q virtualbox-guest-utils-nox &> /dev/null; then
                action_type="uninstall"
                manage_one "virtualbox-guest-utils-nox"
            fi
        fi
        required_deps+="${required_dep}&"
    done

    action_type="install"
    manage_lst "${required_deps}"

    if pacman -Q virtualbox-guest-utils &> /dev/null; then
        exec_log "sudo usermod -aG vboxsf ${USER}" "${GREEN}[+]${RESET} Giving permission for [${YELLOW}VM shared folder${RESET}] (guest machine)"
    fi
}

wam_scripts() {
    prompt_choice "${BLUE}:: ${RESET}Do you want to add [${YELLOW}Wam scripts${RESET}] to [${YELLOW}${HOME}/.bin${RESET}] folder ?" true
    if [[ ${answer} == true ]]; then
        check_dir ${HOME}/.bin "user"
        exec_log "cp '${INSTALL_DIRECTORY}'/_extra/wam_scripts/* ${HOME}/.bin" "${GREEN}[+]${RESET} Copying [${YELLOW}Wam scripts${RESET}] to [${YELLOW}~/.bin${RESET}]"
    fi
}