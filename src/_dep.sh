
remove_useless_kernels() {
    declare -a kernel_to_remove_list
    local packages

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

    log_msg "${GREEN}[+]${RESET} Checking for kernel(s) to remove :${RESET}"

    for kernel in "${kernel_to_remove_list[@]}"; do
        kernels+="${kernel}&"
    done
    action_type="uninstall"
    manage_lst "${kernels}"
}

check_required_dep() {
    declare -a required_dep_list
    local packages

    required_dep_list=(
        file-roller
        gvfs
        gvfs-afc
        gvfs-mtp
        gvfs-nfs
        gvfs-smb
        p7zip
        tldr
        unzip
        zip
    )

    if [[ ! ${VM} == "none" ]]; then
        required_dep_list+=(virtualbox-guest-utils)
    fi

    log_msg "${GREEN}[+]${RESET} Checking for required packages :${RESET}"

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
}