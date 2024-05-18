declare -A dkms_list
declare -A icon_list
declare -A soft_list


selected_packages=""

set_uninstall_list() {

    dkms_list=(
        [broadcom-wl]="broadcom-wl-dkms"
        [rtl8821cu-morrownr]="rtl8821cu-morrownr-dkms-git"
    )

    icon_list=(
        [Sardi]="sardi-icons"
        [Surfn]="surfn-icons-git"
    )

    soft_list=(
        [Clipman]="xfce4-clipman-plugin"
        [neofetch]="neofetch"
        [Parole]="parole"
        [Xfburn]="xfburn"
    )
}

uninstall_software() {
    local mkinitcpio_needed=0
    
    action_type="uninstall"

    set_uninstall_list

    select_from_list dkms_list "DKMS"
    select_from_list icon_list "Icons"
    select_from_list soft_list "Softwares"

    local -r packages="${selected_packages}"

    selected_packages=""

    manage_lst "${packages}"

    additional_uninstall
    
    mkinitcpio
}

mkinitcpio() {
    if [[ ${mkinitcpio_needed} -gt 0 ]]; then
        exec_log "sudo mkinitcpio -P" "${GREEN}[+]${RESET} Building [${YELLOW}initcpio${RESET}] image ${RED}(might be long)${RESET}"
    fi
}

additional_uninstall() {

    ################################################################
    ##########                  Neofetch                  ##########
    ################################################################

    if [[ ${packages} =~ "neofetch" ]]; then
        app_conf="Neofetch"

        if pacman -Q arcolinux-neofetch-git &> /dev/null; then
            exec_log "sudo pacman -Rsn --noconfirm arcolinux-neofetch-git" "${RED}[-]${RESET} Uninstalling [${YELLOW}arcolinux-neofetch-git${RESET}]"
        fi

        exec_log "sed -i '/#alias vneofetch=/ ! s/alias vneofetch=/#alias vneofetch=/' ${HOME}/.zshrc" "${GREEN}[+]${RESET} Configuring [${YELLOW}.zshrc${RESET}] alias (remove 'vneofetch') for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        exec_log "sed -i '/vneofetch/ ! s/neofetch/#neofetch/' ${HOME}/.zshrc" "${GREEN}[+]${RESET} Removing [${YELLOW}neofetch${RESET}] on [${YELLOW}.zshrc${RESET}]"
    fi
}