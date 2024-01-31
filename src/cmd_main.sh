update_system() {
    exec_log "sudo pacman -Syyu --noconfirm" "${GREEN}[+]${RESET} Updating full system ${RED}(might be long)${RESET}"
    log_msg "\n${GREEN}System is up-to-date${RESET}"
}

replace_username() {
    local -r file_to_edit=$1
    local -r message_log=$2

    exec_log "sed -i 's/\*\*\*/${CURRENT_USER}/' ${file_to_edit}" "${message_log}"
}

check_dir() {
    local -r folder=$1
    local -r permission=$2

    if [[ -d ${folder} ]]; then
        log "Folder already exists : ${GREEN}${folder}${RESET}"
    else
        if [[ ${permission} == "user" ]]; then
            exec_log "mkdir -p ${folder// /\\ }" "${GREEN}[+]${RESET} Creating missing folder with [${YELLOW}USER${RESET}] permissions : [${YELLOW}${folder}${RESET}]"
        elif [[ ${permission} == "root" ]]; then
            exec_log "sudo mkdir -p ${folder// /\\ }" "${GREEN}[+]${RESET} Creating missing folder with [${YELLOW}ROOT${RESET}] permissions : [${YELLOW}${folder}${RESET}]"
        fi
    fi
}

select_from_list() {
    declare -n item_list=$1
    local -r type_list=$2
    local i=1
    local options=()
    local input

    printf "%s\n\n" "${GREEN}${type_list}${RESET} :"

    for software in "${!item_list[@]}"; do
        printf "${PURPLE}%2d${RESET}) %s\n" "$i" "$software"
        options+=("$software")
        ((i++))
    done

    if [[ ${action_type} == "install" ]]; then
        printf "\n%s" "${BLUE}:: ${RESET}Packages to install (e.g., 1 2 3, 1-3, (a)ll or press enter to skip): "
    elif [[ ${action_type} == "uninstall" ]]; then
        printf "\n%s" "${BLUE}:: ${RESET}Packages to uninstall (e.g., 1 2 3, 1-3, (a)ll or press enter to skip): "
    elif [[ ${action_type} == "copy_paste" ]]; then
        printf "\n%s" "${BLUE}:: ${RESET}Configuration files to copy/paste (e.g., 1 2 3, 1-3, (a)ll or press enter to skip): "
    elif [[ ${action_type} == "config_system" ]]; then
        printf "\n%s" "${BLUE}:: ${RESET}Configurations to set (e.g., 1 2 3, 1-3, (a)ll or press enter to skip): "
    fi

    read -ra input
    for choice in "${input[@]}"; do
        if [[ "$choice" =~ ^(all|a)$ ]]; then
            for software in "${!item_list[@]}"; do
                selected_packages+=" ${item_list[$software]} "
            done
            break
        elif [[ $choice =~ ^[0-9]+$ ]]; then
            selected_packages+=" ${item_list[${options[$choice - 1]}]} "
        elif [[ $choice =~ ^[0-9]+-[0-9]+$ ]]; then
            IFS='-' read -ra range <<<"$choice"
            for ((j = ${range[0]}; j <= ${range[1]}; j++)); do
                selected_packages+=" ${item_list[${options[$j - 1]}]} "
            done
        fi
    done
    printf "\n"
}

manage_lst() {
    local -r lst=$1
    local -r lst_split=(${lst// / })

    for package in ${lst_split[@]}; do
        manage_one "${package}"
    done
}

manage_one() {
    local -r package=$1
    local -r package_split=(${package//[]/ })
    local -r target=${package_split[0]}
    local -r destination=${package_split[1]}
    local file_name=(${target//// })
    local sudo_str=""
    local warning_msg=""

    local -r warning="
        rtl8821cu-morrownr-dkms-git
        broadcom-wl-dkms
        brave-bin
        thunderbird
        visual-studio-code-bin
        wine
    "
    if [[ ${warning} =~ ${package} ]]; then
        warning_msg="${RED}(might be long)${RESET}"
    fi

    if [[ ${action_type} == "install" ]]; then
        exec_log "sudo pacman -S --noconfirm --needed ${package}" "${GREEN}[+]${RESET} ${package} ${warning_msg}"
    elif [[ ${action_type} == "uninstall" ]]; then
        exec_log "sudo pacman -Rsn --noconfirm ${package}" "${RED}[-]${RESET} ${package} ${warning_msg}"
    elif [[ ${action_type} == "copy_paste" ]]; then
        if [[ "${target}" =~ "/*" ]]; then
            file_name[1]="All files from ${file_name[0]^^} folder"
        fi
        if [[ "${destination}" =~ .*${HOME}.* ]]; then
            check_dir ${destination} "user"
        else
            check_dir ${destination} "root"
            sudo_str="sudo "
        fi
        exec_log "${sudo_str}cp -a ${INSTALL_DIRECTORY}/${target} ${destination}" "${GREEN}[+]${RESET} Copying [${YELLOW}${file_name[1]}${RESET}] to [${YELLOW}${destination}${RESET}]${warning_msg}"
    elif [[ ${action_type} == "config_system" ]]; then
        exec_log "sudo ${package//[]/ }" "${GREEN}[+]${RESET} Setting [${YELLOW}${package_split[-1]}${RESET}] on [${YELLOW}${package_split[0]}${RESET}]"
    fi
}