declare -A vm_list
declare -A font_list
declare -A soft_list
declare -A extra_list

selected_packages=""

function set_install_list() {
    vm_list=(
        [VirtualBox (+ template)]="virtualbox"
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
    )

    extra_list=(
        [KeePassXC]="keepassxc"
        [Nextcloud]="nextcloud-client"
        [Qbittorrent]="qbittorrent"
        [Ventoy]="ventoy-bin"
        [Veracrypt]="veracrypt"
    )
}

function install_software() {
    action_type="install"

    set_install_list

    if [[ ${VM} = "none" ]];then
        select_from_list vm_list "VirtualBox"
    else
        log_msg "${RED}\n[This is a virtual machine - Skipping VirtualBox installation]${RESET}"
    fi

    select_from_list font_list "Font"
    select_from_list soft_list "Required"
    select_from_list extra_list "Extra"

    local -r packages="${selected_packages}"
    selected_packages=""

    manage_lst "${packages}"

    ################################################################
    ##########                 VirtualBox                 ##########
    ################################################################

    if [[ ${packages} =~ "virtualbox" ]]; then
        exec_log "sudo gpasswd -a $USER vboxusers" "${GREEN}[+]${RESET} Add current user to [${YELLOW}vboxusers${RESET}] group"
        exec_log "sudo pacman -S --noconfirm --needed virtualbox-host-dkms" "${GREEN}[+]${RESET} virtualbox-host-dkms${warning_msg}"
        exec_log "sudo pacman -S --noconfirm --needed virtualbox-guest-iso" "${GREEN}[+]${RESET} virtualbox-guest-iso${warning_msg}"
        check_dir ${HOME}/VirtualBox_VMs "user"
        exec_log "tar -xzf ${INSTALL_DIRECTORY}/virtualbox-template/template.tar.gz -C ${HOME}/VirtualBox_VMs" "${GREEN}[+]${RESET} Extracting [${YELLOW}template.tar.gz${RESET}] for virtual machine"

        if pacman -Qi linux &> /dev/null; then
            exec_log "sudo pacman -S --needed linux-headers" "${GREEN}[+]${RESET} linux-headers${warning_msg}"
        fi
    fi

    ################################################################
    ##########        VLC 'pause on click' plug-in        ##########
    ################################################################

    if [[ "${packages}" =~ "vlc" ]]; then
        exec_log "sudo pacman -U --noconfirm --needed ${INSTALL_DIRECTORY}/vlc/vlc-pause-click-plugin-2.2.0-1-x86_64.pkg.tar.zst" "${GREEN}[+]${RESET} Installing [${YELLOW}VLC${RESET}] pause-click plug-in"
    fi

    ################################################################
    ##########                    Wine                    ##########
    ################################################################

    if [[ "${packages}" =~ "wine" ]]; then   

        ################################################################
        ##########             Wine : tracking.dat            ##########
        ################################################################

        if [[  ${CURRENT_RESOLUTION} = "1680x1050" && ${CURRENT_USER} = "wam" ]];then
            check_dir ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman "user"
            exec_log "ln -s /mnt/Win10/Users/${CURRENT_USER^}/AppData/Local/MediaHuman/YouTube\ Downloader ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman" "${GREEN}[+]${RESET} Create symbolic link to [${YELLOW}Win10${RESET}]"
        else
            check_dir ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman/YouTube\ Downloader "user"

            if [[ ${CURRENT_USER} = "wam" ]];then
                exec_log "cp ${INSTALL_DIRECTORY}/wine/youtube-downloader/${CURRENT_USER}-user/tracking.dat ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman/YouTube\ Downloader" "${GREEN}[+]${RESET} Copying [${YELLOW}tracking.dat${RESET}] file to [${YELLOW}${CURRENT_USER^^}${RESET}] 'Youtube downloader' folder"
            else
                exec_log "cp ${INSTALL_DIRECTORY}/wine/youtube-downloader/tracking.dat ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman/YouTube\ Downloader" "${GREEN}[+]${RESET} Copying [${YELLOW}tracking.dat${RESET}] file to [${YELLOW}${CURRENT_USER^^}${RESET}] 'Youtube downloader' folder"
            fi
        fi

        ################################################################
        ##########               Wine : Shortcut              ##########
        ################################################################

        if prompt_default_yes "Do you want to install [${YELLOW}Shortcut${RESET}] (for WINE) ?"; then
            check_dir ${HOME}/.wine/drive_c/windows "user"
            exec_log "cp ${INSTALL_DIRECTORY}/wine/shortcut/shortcut.exe ${HOME}/.wine/drive_c/windows" "${GREEN}[+]${RESET} Copying [${YELLOW}shortcut.exe${RESET}] file to [${YELLOW}WINE${RESET}] folder"
        fi

        ################################################################
        ##########             Wine : Tag renamer             ##########
        ################################################################

        if prompt_default_yes "Do you want to install [${YELLOW}Tag renamer${RESET}] (for WINE) ?"; then
            check_dir ${HOME}/.wine/drive_c/Program\ Files/TagRename "user"
            exec_log "7z x -y ${INSTALL_DIRECTORY}/wine/tag-rename/TagRename.7z -o${HOME}/.wine/drive_c/Program\ Files/TagRename" "${GREEN}[+]${RESET} Extracting [${YELLOW}TagRename.7z${RESET}] files to [${YELLOW}WINE${RESET}] folder\n${RED}/!\ Enter password ! /!\ ${RESET}"
            
            check_dir ${HOME}/.wine/drive_c/ProgramData/Microsoft/Windows/Start\ Menu/Programs/TagRename "user"
            exec_log "wine shortcut /f:'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TagRename\TagRename.lnk' /a:c /t:'C:\Program Files\TagRename\TagRename.exe' /i:'C:\Program Files\TagRename\TagRename.exe,0'" "${GREEN}[+]${RESET} [${YELLOW}WINE${RESET}] : Creating [${YELLOW}TagRename.lnk${RESET}] ${RED}(might be long)${RESET}"
            sleep 3

            check_dir ${HOME}/.local/share/applications/wine/Programs/TagRename "user"
            exec_log "cp ${INSTALL_DIRECTORY}/wine/tag-rename/TagRename.desktop ${HOME}/.local/share/applications/wine/Programs/TagRename" "${GREEN}[+]${RESET} Copying [${YELLOW}TagRename.desktop${RESET}] file to [${YELLOW}${CURRENT_USER^^}${RESET}] folder"

            local ICON_FILENAME=$(find ~ -name "*TagRename*.png" -printf "%f" -quit)
            ICON_FILENAME=${ICON_FILENAME%.*}
            exec_log "sed -i 's/Icon=/Icon=$ICON_FILENAME/' ${HOME}/.local/share/applications/wine/Programs/TagRename/TagRename.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}TagRename.desktop${RESET}] : changing icon filename to [${YELLOW}${ICON_FILENAME}${RESET}]"
            replace_username "${HOME}/.local/share/applications/wine/Programs/TagRename/TagRename.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}TagRename.desktop${RESET}] : changing username to [${YELLOW}${CURRENT_USER^^}${RESET}]"
        fi

        ################################################################
        ##########          Wine : Youtube downloader         ##########
        ################################################################

        if prompt_default_yes "Do you want to install [${YELLOW}Youtube downloader${RESET}] (for WINE) ?"; then

            local -r file="$HOME/Downloads/YouTubeDownloader-x64.exe"

            if [[ -f ${file} ]];then
                log_msg "${GREEN}${file} already exists${RESET}"
            else
                log_msg "${RED}${file} doesn't exist - Downloading now : '${RESET}"
                exec_log "wget -O ${HOME}/Downloads/YouTubeDownloader-x64.exe https://www.mediahuman.com/fr/download/YouTubeDownloader-x64.exe" "${GREEN}[+]${RESET} Downloading [${YELLOW}YouTubeDownloader-x64.exe${RESET}] ${RED}(might be long)${RESET}"
            fi

            exec_log "wine ${HOME}/Downloads/YouTubeDownloader-x64.exe" "${GREEN}[+]${RESET} [${YELLOW}WINE${RESET}] : Installing [${YELLOW}YouTubeDownloader-x64.exe${RESET}] to [${YELLOW}WINE${RESET}] folder ${RED}(might be long)${RESET}"
            sleep 3
            
            exec_log "rm -v ${HOME}/Desktop/MediaHuman\ YouTube\ Downloader.lnk" "${RED}[-]${RESET} Removing [${YELLOW}MediaHuman YouTube Downloader.lnk${RESET}] desktop shortcut"
            exec_log "rm -v ${HOME}/Desktop/Visit\ MediaHuman\ Website.url" "${RED}[-]${RESET} Removing [${YELLOW}Visit MediaHuman Website.url${RESET}] desktop shortcut"
            exec_log "rm -v ${HOME}/Desktop/MediaHuman\ YouTube\ Downloader.desktop" "${RED}[-]${RESET} Removing [${YELLOW}MediaHuman YouTube Downloader.desktop${RESET}] desktop shortcut"

            check_dir ${HOME}/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader "user"
            exec_log "cp ${INSTALL_DIRECTORY}/wine/youtube-downloader/MediaHuman\ YouTube\ Downloader.desktop ${HOME}/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader" "${GREEN}[+]${RESET} Copying [${YELLOW}MediaHuman YouTube Downloader.desktop${RESET}] file to [${YELLOW}${CURRENT_USER^^}${RESET}] folder"
            replace_username "${HOME}/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader/MediaHuman\ YouTube\ Downloader.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}MediaHuman YouTube Downloader.desktop${RESET}] : changing username to [${YELLOW}${CURRENT_USER^^}${RESET}]"
        fi
    fi
}
