source src/getLastSyncWord.sh

declare -A vm_list
declare -A font_icon_list
declare -A soft_list
declare -A extra_list

selected_packages=""

set_install_list() {
    vm_list=(
        [VirtualBox \(+ template\)]="virtualbox"
    )

    font_icon_list=(
        [Noto fonts - emoji]="noto-fonts-emoji"
        [we10x icon theme]="we10x-icon-theme-git"
    )

    soft_list=(
        [Brave]="brave-bin"
        [Catfish]="catfish"
        [Conky]="conky-lua-archers"
        [Font manager]="font-manager"
        [Galculator]="galculator"
        [Meld]="meld"
        [Plank]="plank"
        [Thunderbird]="thunderbird"
        [Visual studio code]="visual-studio-code-bin"
        [VLC]="vlc"
        [Wine]="wine"
        [Xreader]="xreader"
    )

    extra_list=(
        [KeePassXC]="keepassxc"
        [Nextcloud]="nextcloud-client"
        [Qbittorrent]="qbittorrent"
        [Simple scan]="simple-scan"
        [Ventoy]="ventoy-bin"
        [Veracrypt]="veracrypt"
    )
}

install_software() {
    action_type="install"
    
    set_install_list

    if [[ ${VM} == "none" ]]; then
        select_from_list vm_list "VirtualBox"
        select_from_list extra_list "Extra"
    else
        log_msg "${RED}[This is a virtual machine] - Skipping VirtualBox and 'extra' installation${RESET}\n"
    fi

    select_from_list font_icon_list "Font & icons"
    select_from_list soft_list "Needed"

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

    if [[ ${packages} =~ "brave-bin" && ${extra_install[brave-bin]} == true ]]; then
        app_conf="Brave"

        fetch_password
        exec_log "7z x -p${PASSWORD} -y ${INSTALL_DIRECTORY}/brave/sync_code.7z -o${HOME}/Documents" "${GREEN}[+]${RESET} Extracting [${YELLOW}sync_code.7z${RESET}] to [${YELLOW}${HOME}/Documents${RESET}]"
        fetch_the_25th_word
        exec_log "sed -i 's/the25thWord/${the25thWord}/' ${HOME}/Documents/sync_code.txt" "${GREEN}[+]${RESET} Adding today's 25th word [${YELLOW}${the25thWord^^}${RESET}] to [${YELLOW}sync_code.txt${RESET}]"
    fi

    ################################################################
    ##########                   Conky                    ##########
    ################################################################
    # [Conky : Conky WAM & USER config. and alias]="conky/conky-sessionfile ${HOME}/.config/conky"
    if [[ ${packages} =~ "conky-lua-archers" && ${extra_install[conky-lua-archers]} == true ]]; then

        ################################################################
        ##########                Conky : WAM                 ##########
        ##########            User config & alias             ##########
        ################################################################
        prompt_choice "${BLUE}:: ${RESET}Do you want to install [${YELLOW}WAM conky${RESET}] ?" true
        if [[ ${answer} == true ]]; then
            app_conf="Conky : WAMconky"

            check_dir ${HOME}/.config/conky "user"
            exec_log "cp ${INSTALL_DIRECTORY}/conky/conky-sessionfile ${HOME}/.config/conky" "${GREEN}[+]${RESET} Copying [${YELLOW}conky-sessionfile${RESET}] file to [${YELLOW}${HOME}/.config/conky${RESET}] folder"
            replace_username "${HOME}/.config/conky/conky-sessionfile" "${GREEN}[+]${RESET} Configuring [${YELLOW}conky-sessionfile${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
            exec_log "cp ${INSTALL_DIRECTORY}/conky/WAM.conkyrc ${HOME}/.config/conky" "${GREEN}[+]${RESET} Copying [${YELLOW}WAM.conkyrc${RESET}] file to [${YELLOW}${HOME}/.config/conky${RESET}] folder"
            exec_log "cp ${INSTALL_DIRECTORY}/conky/wam_fetch_icon.sh ${HOME}/.config/conky" "${GREEN}[+]${RESET} Copying [${YELLOW}wam_fetch_icon.sh${RESET}] file to [${YELLOW}${HOME}/.config/conky${RESET}] folder"
            exec_log "cp ${INSTALL_DIRECTORY}/conky/wam_color_switch.sh ${HOME}/.config/conky" "${GREEN}[+]${RESET} Copying [${YELLOW}wam_color_switch.sh${RESET}] file to [${YELLOW}${HOME}/.config/conky${RESET}] folder"

            exec_log "grep -qxF '# Switch conky colors' ${HOME}/.bashrc-personal || printf '\n%s\n%s\n' '# Switch conky colors' 'alias conky-switch=\". ~/.config/conky/wam_color_switch.sh\"' | sudo tee -a ${HOME}/.bashrc-personal" "${GREEN}[+]${RESET} Adding [${YELLOW}conky-switch alias${RESET}] to [${YELLOW}${HOME}/.bashrc-personal${RESET}]"
            exec_log "grep -qxF '# Switch conky colors' ${HOME}/.zshrc-personal || printf '\n%s\n%s\n' '# Switch conky colors' 'alias conky-switch=\". ~/.config/conky/wam_color_switch.sh\"' | sudo tee -a ${HOME}/.zshrc-personal" "${GREEN}[+]${RESET} Adding [${YELLOW}conky-switch alias${RESET}] to [${YELLOW}${HOME}/.zshrc-personal${RESET}]"

            check_dir ${HOME}/.config/conky/images "user"
            fetch_password
            exec_log "7z x -p${PASSWORD} -y ${INSTALL_DIRECTORY}/conky/meteo-icons.7z -o${HOME}/.config/conky/images" "${GREEN}[+]${RESET} Extracting [${YELLOW}meteo-icons.7z${RESET}] to [${YELLOW}${HOME}/.config/conky/images/meteo-icons${RESET}]"
            
            check_dir ${HOME}/.cache/openmeteo "user"
            
            exec_log "sudo cp -a ${INSTALL_DIRECTORY}/fonts/Bentoh_mod.ttf /usr/share/fonts/TTF" "${GREEN}[+]${RESET} Copying [${YELLOW}Bentoh_mod.ttf${RESET}] font to [${YELLOW}/usr/share/fonts/TTF${RESET}]"
            exec_log "sudo cp -a ${INSTALL_DIRECTORY}/fonts/Californication.ttf /usr/share/fonts/TTF" "${GREEN}[+]${RESET} Copying [${YELLOW}Californication.ttf${RESET}] font to [${YELLOW}/usr/share/fonts/TTF${RESET}]"
            exec_log "sudo cp -a ${INSTALL_DIRECTORY}/fonts/Rallifornia.ttf /usr/share/fonts/TTF" "${GREEN}[+]${RESET} Copying [${YELLOW}Rallifornia.ttf${RESET}] font to [${YELLOW}/usr/share/fonts/TTF${RESET}]"
            exec_log "sudo cp -a ${INSTALL_DIRECTORY}/fonts/TechnicalCE.ttf /usr/share/fonts/TTF" "${GREEN}[+]${RESET} Copying [${YELLOW}TechnicalCE.ttf${RESET}] font to [${YELLOW}/usr/share/fonts/TTF${RESET}]"
            exec_log "sudo fc-cache -fv" "${GREEN}[+]${RESET} Building [${YELLOW}fonts${RESET}] cache file"
        fi
    fi

    ################################################################
    ##########                Font manager                ##########
    ################################################################

    if [[ ${packages} =~ "font-manager" && ${extra_install[font-manager]} == true ]]; then
        app_conf="Font manager"

        check_dir ${HOME}/.config/font-manager "user"
        exec_log "cp ${INSTALL_DIRECTORY}/font-manager/Actions.json ${HOME}/.config/font-manager" "${GREEN}[+]${RESET} Copying [${YELLOW}Actions.json${RESET}] file to [${YELLOW}~/.config/font-manager${RESET}] folder"
    fi

    ################################################################
    ##########                 Nextcloud                  ##########
    ################################################################

    if [[ ${package} =~ "nextcloud-client" && ${extra_install[nextcloud-client]} == true ]]; then
        check_dir ${HOME}/Documents/[Nextcloud] "user"
    fi

    ################################################################
    ##########                Thunderbird                 ##########
    ################################################################

    if [[ ${packages} =~ "thunderbird" && ${extra_install[thunderbird]} == true ]]; then
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

    if [[ ${packages} =~ "virtualbox" && ${extra_install[virtualbox]} == true ]]; then
        app_conf="Virtualbox"

        manage_one "virtualbox-host-modules-arch"
        if pacman -Qi linux &> /dev/null; then
            manage_one "linux-headers"
        fi

        exec_log "sudo gpasswd -a ${USER} vboxusers" "${GREEN}[+]${RESET} Add current user to [${YELLOW}vboxusers${RESET}] group"

        check_dir ${HOME}/VirtualBox_VMs "user"
        exec_log "tar -xf ${INSTALL_DIRECTORY}/virtualbox-template/template.tar.gz -C ${HOME}/VirtualBox_VMs" "${GREEN}[+]${RESET} Extracting [${YELLOW}template.tar.gz${RESET}] for virtual machine"
    fi

    ################################################################
    ##########        VLC 'pause on click' plug-in        ##########
    ################################################################

    if [[ ${packages} =~ "vlc" && ${extra_install[vlc]} == true ]]; then
        app_conf="VLC 'pause on click' plug-in"

        exec_log "sudo pacman -U --noconfirm --needed ${INSTALL_DIRECTORY}/vlc/vlc-pause-click-plugin-2.2.0-1-x86_64.pkg.tar.zst" "${GREEN}[+]${RESET} Installing [${YELLOW}VLC${RESET}] pause-click plug-in"
    fi

    ################################################################
    ##########                    Wine                    ##########
    ################################################################

    if [[ ${packages} =~ "wine" && ${extra_install[wine]} == true ]]; then

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
            fetch_password
            exec_log "7z x -p${PASSWORD} -y ${INSTALL_DIRECTORY}/wine/tag-rename/TagRename.7z -o${HOME}/.wine/drive_c/Program\ Files/TagRename" "${GREEN}[+]${RESET} Extracting [${YELLOW}TagRename.7z${RESET}] files to [${YELLOW}WINE${RESET}] folder"
            
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
                exec_log "ln -s -f /mnt/Win11/Users/${CURRENT_USER^}/AppData/Local/MediaHuman/YouTube\ Downloader ${HOME}/.wine/drive_c/users/${CURRENT_USER}/AppData/Local/MediaHuman" "${GREEN}[+]${RESET} Create symbolic link to [${YELLOW}Win11${RESET}]"
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