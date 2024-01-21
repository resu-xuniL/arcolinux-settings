declare -A dkms_list
declare -A icon_list
declare -A soft_list


selected_packages=""

function set_uninstall_list() {

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
        [Parole]="parole"
        [Xfburn]="xfburn"
    )
}

function uninstall_software() {
    local mkinitcpio_needed=0
    
    action_type="uninstall"

    set_uninstall_list

    select_from_list dkms_list "DKMS"
    select_from_list icon_list "Icons"
    select_from_list soft_list "Softwares"

    local -r packages="${selected_packages}"

    selected_packages=""

    manage_lst "${packages}"

    ################################################################
    ##########            DKMS Uninstallation             ##########
    ################################################################

    if [[ "${packages}" =~ "broadcom-wl-dkms" || "${packages}" =~ "rtl8821cu-morrownr-dkms-git" ]];then
        if [[ ${mkinitcpio_needed} -gt 0 ]]; then
            exec_log "sudo mkinitcpio -P" "${GREEN}[+]${RESET} Building [${YELLOW}initcpio${RESET}] image ${RED}(might be long)${RESET}"
        fi
    fi
}