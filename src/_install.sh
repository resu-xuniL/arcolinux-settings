source src/getLastSyncWord.sh

declare -A vm_list
declare -A font_list
declare -A soft_list
declare -A extra_list

selected_packages=""

set_install_list() {
    vm_list=(
        [VirtualBox \(+ template\)]="virtualbox"
    )

    font_list=(
        [Noto fonts - emoji]="noto-fonts-emoji"
        [we10x icon theme]="we10x-icon-theme-git"
    )

    soft_list=(
        [Brave]="brave-bin"
        [Galculator]="galculator"
        [Meld]="meld"
        [Plank]="plank"
        [Thunderbird]="thunderbird"
        [Visual studio code]="visual-studio-code-bin"
        [VLC]="vlc"
        [Wine]="wine"
        [Foliate]="foliate"
    )

    extra_list=(
        [KeePassXC]="keepassxc"
        [Nextcloud]="nextcloud-client"
        [Qbittorrent]="qbittorrent"
        [Ventoy]="ventoy-bin"
        [Veracrypt]="veracrypt"
    )
}

install_software() {
    local password=""
    action_type="install"
    
    set_install_list

    if [[ ${VM} == "none" ]]; then
        select_from_list vm_list "VirtualBox"
    else
        log_msg "${RED}[This is a virtual machine - Skipping VirtualBox installation]${RESET}\n"
    fi

    select_from_list font_list "Font"
    select_from_list soft_list "Needed"
    select_from_list extra_list "Extra"

    local -r packages="${selected_packages}"
    selected_packages=""

    manage_lst "${packages}"
    config_apps
}

config_apps() {
    action_type="config_apps"

    ################################################################
    ##########                   Brave                    ##########
    ################################################################

    if [[ ${packages} =~ "brave-bin" ]]; then
        app_conf="Brave"

        [[ -n "${password}" ]] || password=$(whiptail --nocancel --title "Password for 7z archives" --passwordbox "Enter your password below." 8 50 3>&1 1>&2 2>&3)
        exec_log "7z x -p${password} -y ${INSTALL_DIRECTORY}/brave/sync_code.7z -o${HOME}/Documents" "${GREEN}[+]${RESET} Extracting [${YELLOW}sync_code.7z${RESET}] to [${YELLOW}${HOME}/Documents${RESET}]"
        fetch_the_25th_word
        exec_log "sed -i 's/the25thWord/${the25thWord}/' ${HOME}/Documents/sync_code.txt" "${GREEN}[+]${RESET} Adding today's 25th word [${YELLOW}${the25thWord^^}${RESET}] to [${YELLOW}sync_code.txt${RESET}]"
    fi

    ################################################################
    ##########                 Nextcloud                  ##########
    ################################################################

    if [[ ${package} == "nextcloud-client" ]]; then
        check_dir ${HOME}/Documents/[Nextcloud] "user"
    fi

    ################################################################
    ##########                Thunderbird                 ##########
    ################################################################

    if [[ ${packages} =~ "thunderbird" ]]; then
        app_conf="Thunderbird"

        if ! exist ${HOME}/.thunderbird/*.default-*; then
            exec_log "thunderbird" "${GREEN}[+]${RESET} Starting [${YELLOW}thunderbird${RESET}]"
        fi

        thunderbird_dir=$(find ~/.thunderbird/ -name '*.default-*' -type d)
        exec_log "cp ${INSTALL_DIRECTORY}/thunderbird/handlers.json ${thunderbird_dir}" "${GREEN}[+]${RESET} Copying [${YELLOW}handlers.json${RESET}] file to [${YELLOW}${thunderbird_dir}${RESET}] folder"
    fi

    ################################################################
    ##########                 VirtualBox                 ##########
    ################################################################

    if [[ ${packages} =~ "virtualbox" ]]; then
        app_conf="Virtualbox"

        exec_log "sudo gpasswd -a $USER vboxusers" "${GREEN}[+]${RESET} Add current user to [${YELLOW}vboxusers${RESET}] group"
        manage_lst "virtualbox-host-dkms virtualbox-guest-iso"
        check_dir ${HOME}/VirtualBox_VMs "user"
        exec_log "tar -xzf ${INSTALL_DIRECTORY}/virtualbox-template/template.tar.gz -C ${HOME}/VirtualBox_VMs" "${GREEN}[+]${RESET} Extracting [${YELLOW}template.tar.gz${RESET}] for virtual machine"

        if pacman -Qi linux &> /dev/null; then
            manage_one "linux-headers"
        fi
    fi

    ################################################################
    ##########        VLC 'pause on click' plug-in        ##########
    ################################################################

    if [[ ${packages} =~ "vlc" ]]; then
        app_conf="VLC 'pause on click' plug-in"

        exec_log "sudo pacman -U --noconfirm --needed ${INSTALL_DIRECTORY}/vlc/vlc-pause-click-plugin-2.2.0-1-x86_64.pkg.tar.zst" "${GREEN}[+]${RESET} Installing [${YELLOW}VLC${RESET}] pause-click plug-in"
    fi

    ################################################################
    ##########                    Wine                    ##########
    ################################################################

    if [[ ${packages} =~ "wine" ]]; then

        ################################################################
        ##########               Wine : Shortcut              ##########
        ################################################################

        prompt_choice "${BLUE}:: ${RESET}Do you want to install [${YELLOW}Shortcut${RESET}] (for WINE) ?" true
        if [[ ${answer} == true ]]; then
            app_conf="Wine : Shortcut"

            check_dir ${HOME}/.wine/drive_c/windows "user"
            exec_log "cp ${INSTALL_DIRECTORY}/wine/shortcut/shortcut.exe ${HOME}/.wine/drive_c/windows" "${GREEN}[+]${RESET} Copying [${YELLOW}shortcut.exe${RESET}] file to [${YELLOW}WINE${RESET}] folder"
        fi

        ################################################################
        ##########             Wine : Tag renamer             ##########
        ################################################################

        prompt_choice "${BLUE}:: ${RESET}Do you want to install [${YELLOW}Tag renamer${RESET}] (for WINE) ?" true
        if [[ ${answer} == true ]]; then
            app_conf="Wine : Tag renamer"

            check_dir ${HOME}/.wine/drive_c/Program\ Files/TagRename "user"
            [[ -n "${password}" ]] || password=$(whiptail --nocancel --title "Password for 7z archives" --passwordbox "Enter your password below." 8 50 3>&1 1>&2 2>&3)
            exec_log "7z x -p${password} -y ${INSTALL_DIRECTORY}/wine/tag-rename/TagRename.7z -o${HOME}/.wine/drive_c/Program\ Files/TagRename" "${GREEN}[+]${RESET} Extracting [${YELLOW}TagRename.7z${RESET}] files to [${YELLOW}WINE${RESET}] folder"
            
            check_dir ${HOME}/.wine/drive_c/ProgramData/Microsoft/Windows/Start\ Menu/Programs/TagRename "user"
            exec_log "wine shortcut /f:'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TagRename\TagRename.lnk' /a:c /t:'C:\Program Files\TagRename\TagRename.exe' /i:'C:\Program Files\TagRename\TagRename.exe,0'" "${GREEN}[+]${RESET} [${YELLOW}WINE${RESET}] : Creating [${YELLOW}TagRename.lnk${RESET}] ${RED}(might be long)${RESET}"
            sleep 3

            check_dir ${HOME}/.local/share/applications/wine/Programs/TagRename "user"
            exec_log "cp ${INSTALL_DIRECTORY}/wine/tag-rename/TagRename.desktop ${HOME}/.local/share/applications/wine/Programs/TagRename" "${GREEN}[+]${RESET} Copying [${YELLOW}TagRename.desktop${RESET}] file to [${YELLOW}${CURRENT_USER^^}${RESET}] folder"

            local icon_filename=$(find ~ -name "*TagRename*.png" -printf "%f" -quit)
            icon_filename=${icon_filename%.*}
            exec_log "sed -i 's/Icon=/Icon=$icon_filename/' ${HOME}/.local/share/applications/wine/Programs/TagRename/TagRename.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}TagRename.desktop${RESET}] : changing icon filename to [${YELLOW}${icon_filename}${RESET}]"
            replace_username "${HOME}/.local/share/applications/wine/Programs/TagRename/TagRename.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}TagRename.desktop${RESET}] : changing username to [${YELLOW}${CURRENT_USER^^}${RESET}]"
        fi

        ################################################################
        ##########          Wine : Youtube downloader         ##########
        ################################################################

        prompt_choice "${BLUE}:: ${RESET}Do you want to install [${YELLOW}Youtube downloader${RESET}] (for WINE) ?" true
        if [[ ${answer} == true ]]; then
            app_conf="Wine : Youtube downloader"
            
            local -r file="YouTubeDownloader-x64.exe"

            if [[ -f ${HOME}/Downloads/${file} ]]; then
                log_msg "${GREEN}[OK] ${file} already exists${RESET}\n"
            else
                log_msg "${RED}[KO] ${file} doesn't exist - Downloading now${RESET}\n"
                exec_log "wget -O ${HOME}/Downloads/${file} https://www.mediahuman.com/fr/download/${file}" "${GREEN}[+]${RESET} Downloading [${YELLOW}${file}${RESET}] ${RED}(might be long)${RESET}"
            fi

            exec_log "wine ${HOME}/Downloads/${file}" "${GREEN}[+]${RESET} [${YELLOW}WINE${RESET}] : Installing [${YELLOW}${file}${RESET}] to [${YELLOW}WINE${RESET}] folder ${RED}(might be long)${RESET}"
            sleep 3
            
            exec_log "rm -v ${HOME}/Desktop/MediaHuman\ YouTube\ Downloader.lnk" "${RED}[-]${RESET} Removing [${YELLOW}MediaHuman YouTube Downloader.lnk${RESET}] desktop shortcut"
            exec_log "rm -v ${HOME}/Desktop/Visit\ MediaHuman\ Website.url" "${RED}[-]${RESET} Removing [${YELLOW}Visit MediaHuman Website.url${RESET}] desktop shortcut"
            exec_log "rm -v ${HOME}/Desktop/MediaHuman\ YouTube\ Downloader.desktop" "${RED}[-]${RESET} Removing [${YELLOW}MediaHuman YouTube Downloader.desktop${RESET}] desktop shortcut"

            check_dir ${HOME}/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader "user"
            exec_log "cp ${INSTALL_DIRECTORY}/wine/youtube-downloader/MediaHuman\ YouTube\ Downloader.desktop ${HOME}/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader" "${GREEN}[+]${RESET} Copying [${YELLOW}MediaHuman YouTube Downloader.desktop${RESET}] file to [${YELLOW}${CURRENT_USER^^}${RESET}] folder"
            replace_username "${HOME}/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader/MediaHuman\ YouTube\ Downloader.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}MediaHuman YouTube Downloader.desktop${RESET}] : changing username to [${YELLOW}${CURRENT_USER^^}${RESET}]"
        
            exec_log "cp ${INSTALL_DIRECTORY}/wine/youtube-downloader/MediaHuman\ YouTube\ Downloader\ RAZ.reg ${HOME}/.wine/drive_c" "${GREEN}[+]${RESET} Copying [${YELLOW}MediaHuman YouTube Downloader RAZ.reg${RESET}] file to [${YELLOW}${HOME}/.wine/drive_c${RESET}] folder"
            
            check_dir ${HOME}/.local/share/applications "user"
            exec_log "cp ${INSTALL_DIRECTORY}/wine/wine-regedit.desktop ${HOME}/.local/share/applications" "${GREEN}[+]${RESET} Copying [${YELLOW}wine-regedit.desktop${RESET}] shortcut for .reg files to [${YELLOW}${HOME}/.local/share/applications${RESET}] folder"

            exec_log "grep -qxF 'text/x-ms-regedit=wine-regedit.desktop' ${HOME}/.config/mimeapps.list || printf '%s\n' 'text/x-ms-regedit=wine-regedit.desktop' | sudo tee -a ${HOME}/.config/mimeapps.list" "${GREEN}[+]${RESET} Adding [${YELLOW}regedit to wine${RESET}] association to [${YELLOW}mimeapps.list${RESET}]"

            ################################################################
            ##########      Youtube downloader : tracking.dat     ##########
            ################################################################
            
            app_conf="Wine : Youtube downloader - tracking.dat"

            if [[ ${CURRENT_RESOLUTION} == "1680x1050" && ${CURRENT_USER} == "wam" ]]; then
                check_dir ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman "user"
                exec_log "ln -s /mnt/Win10/Users/${CURRENT_USER^}/AppData/Local/MediaHuman/YouTube\ Downloader ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman" "${GREEN}[+]${RESET} Create symbolic link to [${YELLOW}Win10${RESET}]"
            else
                check_dir ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman/YouTube\ Downloader "user"

                if [[ ${CURRENT_USER} == "wam" ]]; then
                    exec_log "cp ${INSTALL_DIRECTORY}/wine/youtube-downloader/${CURRENT_USER}-user/tracking.dat ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman/YouTube\ Downloader" "${GREEN}[+]${RESET} Copying [${YELLOW}tracking.dat${RESET}] file to [${YELLOW}${CURRENT_USER^^}${RESET}] 'Youtube downloader' folder"
                else
                    exec_log "cp ${INSTALL_DIRECTORY}/wine/youtube-downloader/tracking.dat ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman/YouTube\ Downloader" "${GREEN}[+]${RESET} Copying [${YELLOW}tracking.dat${RESET}] file to [${YELLOW}${CURRENT_USER^^}${RESET}] 'Youtube downloader' folder"
                fi
            fi
        fi
    fi
}