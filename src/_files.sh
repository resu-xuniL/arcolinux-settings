declare -A root_config_files_list
declare -A user_config_files_list

selected_packages=""

set_config_files_list() {

    root_config_files_list=(
        [GRUB : Change theme and edit settings]="grub/theme.txt /boot/grub/themes/Vimix"
        [Pacman hook : check for orphans at update]="pacman.hook/check-orphaned.hook /etc/pacman.d/hooks"
        [Resolv : set 1.1.1.1 DNS]="dns/resolv.conf /etc"
        [Samba : Edit config.]="samba/smb.conf /etc/samba"
        [SDDM : Enable arcolinux-sugar-candy theme]="sddm/kde_settings.conf /etc/sddm.conf.d"
    )

    user_config_files_list=(
        [Autostart applications]="autostart/* ${HOME}/.config/autostart"
        [Inputrc : Disable \"^\[\[200~\" on terminal]="terminal/.inputrc ${HOME}"
        [Plank]="plank/* ${HOME}/.config/plank/dock1/launchers"
        [Qt applications : set dark theme]="qt5ct/qt5ct.conf ${HOME}/.config/qt5ct"
        [Shell : personal aliases for BASH]="shell/.bashrc-personal ${HOME}"
        [Shell : personal aliases for ZSH]="shell/.zshrc-personal ${HOME}"
        [Shell : ZSH (with powerline theme)]="shell/.zshrc ${HOME}"
        [Thunar : bookmarks]="gtk3/bookmarks ${HOME}/.config/gtk-3.0"
        [Thunar : Personal actions]="thunar/uca.xml ${HOME}/.config/Thunar"
        [Variety]="variety/variety.conf ${HOME}/.config/variety"
        [VLC : Enable pause-click plug-in]="vlc/vlcrc ${HOME}/.config/vlc"
        [VLC : Customize interface]="vlc/vlc-qt-interface.conf ${HOME}/.config/vlc"
        [VSCodium settings]="vscodium/settings.json ${HOME}/.config/VSCodium/User"
        [VSCodium snippets]="vscodium/shellscript.json ${HOME}/.config/VSCodium/User/snippets"
        [XFCE settings : Keyboard shortcut - Thunar config - Theme - Icons]="xfce/* ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml"
    )
}

config_files() {
    action_type="copy_paste"

    set_config_files_list

    select_from_list root_config_files_list "Copy configuration files with ROOT's permissions"
    select_from_list user_config_files_list "Copy configuration files with USER's permissions"

    local -r packages="${selected_packages}"

    selected_packages=""

    manage_lst "${packages}"

    set_config_files
}

set_config_files() {
    action_type="config_files"

    ################################################################
    ##########             Personal bookmarks             ##########
    ################################################################

    if [[ ${packages} =~ "gtk3/bookmarks" ]]; then
        file_conf="Personal bookmarks"

        if [[ ${VM} == "none" ]]; then
            check_dir ${HOME}/VirtualBox_VMs/_SharedFolder "user"
            exec_log "printf '%s\n' 'file:///home/***/VirtualBox_VMs/_SharedFolder VM shared folder' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}VM shared folder${RESET}] bookmark"

            if [[ ${CURRENT_RESOLUTION} == "1680x1050" ]]; then
                exec_log "printf '%s\n' 'file:///mnt/Swap%20%5B511%20Go%5D/%5BFilms%5D' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}[Films]${RESET}] bookmark"
                exec_log "printf '%s\n' 'file:///mnt/Swap%20%5B511%20Go%5D/%5BVU%5D' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}[VU]${RESET}] bookmark"
                exec_log "printf '%s\n' 'file:///mnt/Storage%20%5B200%20Go%5D/Tools/%5BLinux%5D/%5BVideos%5D [Storage : Linux Videos]' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}[Storage : Linux Videos]${RESET}] bookmark"

                ################################################################
                ######## Setting auto-mount for other (NTFS) partitions ########
                ################################################################

                exec_log "grep -qxF 'UUID=B886C1FD86C1BBDE /mnt/Win11 auto nosuid,nodev,nofail,x-gvfs-show 0 0' /etc/fstab || printf '%s\n' 'UUID=B886C1FD86C1BBDE /mnt/Win11 auto nosuid,nodev,nofail,x-gvfs-show 0 0' | sudo tee -a /etc/fstab" "${GREEN}[+]${RESET} Setting auto-mount for [${YELLOW}Win11${RESET}] (NTFS) partition on [${YELLOW}fstab${RESET}] file"
                exec_log "grep -qxF 'UUID=0AAEA709AEA6EC7F /mnt/Utils\040[20\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' /etc/fstab || printf '%s\n' 'UUID=0AAEA709AEA6EC7F /mnt/Utils\040[20\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' | sudo tee -a /etc/fstab" "${GREEN}[+]${RESET} Setting auto-mount for [${YELLOW}Utils [20 Go]${RESET}] (NTFS) partition on [${YELLOW}fstab${RESET}] file"
                exec_log "grep -qxF 'UUID=4278D51A78D50D93 /mnt/Games\040[200\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' /etc/fstab || printf '%s\n' 'UUID=4278D51A78D50D93 /mnt/Games\040[200\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' | sudo tee -a /etc/fstab" "${GREEN}[+]${RESET} Setting auto-mount for [${YELLOW}Games [200 Go]${RESET}] (NTFS) partition on [${YELLOW}fstab${RESET}] file"
                exec_log "grep -qxF 'UUID=505AE3315AE31310 /mnt/Storage\040[200\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' /etc/fstab || printf '%s\n' 'UUID=505AE3315AE31310 /mnt/Storage\040[200\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' | sudo tee -a /etc/fstab" "${GREEN}[+]${RESET} Setting auto-mount for [${YELLOW}Storage [200 Go]${RESET}] (NTFS) partition on [${YELLOW}fstab${RESET}] file"
                exec_log "grep -qxF 'UUID=904E76144E75F2F8 /mnt/Swap\040[511\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' /etc/fstab || printf '%s\n' 'UUID=904E76144E75F2F8 /mnt/Swap\040[511\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' | sudo tee -a /etc/fstab" "${GREEN}[+]${RESET} Setting auto-mount for [${YELLOW}Swap [511 Go]${RESET}] (NTFS) partition on [${YELLOW}fstab${RESET}] file"
                exec_log "grep -qxF 'UUID=46C4A652C4A64451 /mnt/Videos\040[232\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' /etc/fstab || printf '%s\n' 'UUID=46C4A652C4A64451 /mnt/Videos\040[232\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' | sudo tee -a /etc/fstab" "${GREEN}[+]${RESET} Setting auto-mount for [${YELLOW}Videos [232 Go]${RESET}] (NTFS) partition on [${YELLOW}fstab${RESET}] file"
                exec_log "grep -qxF 'UUID=7E38CE3238CDE96B /mnt/Archives\040[465\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' /etc/fstab || printf '%s\n' 'UUID=7E38CE3238CDE96B /mnt/Archives\040[465\040Go] auto nosuid,nodev,nofail,x-gvfs-show 0 0' | sudo tee -a /etc/fstab" "${GREEN}[+]${RESET} Setting auto-mount for [${YELLOW}Archives [465 Go]${RESET}] (NTFS) partition on [${YELLOW}fstab${RESET}] file"
            fi          
        fi
        replace_username "${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Setting [${YELLOW}Thunar bookmarks${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
    fi

    ################################################################
    ##########           Autostart applications           ##########
    ################################################################

    if [[ ${packages} =~ "autostart" ]]; then
        file_conf="Autostart applications"

        exec_log "cp ${INSTALL_DIRECTORY}/_extra/.login.sound.mp3 ${HOME}" "${GREEN}[+]${RESET} Copying [${YELLOW}.login.sound.mp3${RESET}] to [${YELLOW}${HOME}${RESET}]"
        replace_username "${HOME}/.config/autostart/login.sound.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}Login sound${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
    
        exec_log "rm -v ${HOME}/.config/autostart/xfce4-clipman-plugin-autostart.desktop" "${RED}[-]${RESET} Removing [${YELLOW}xfce4-clipman-plugin${RESET}] from autostart folder"
    fi

    ################################################################
    ##########                    DNS                     ##########
    ################################################################

    if [[ ${packages} =~ "dns/resolv.conf" ]]; then
        file_conf="DNS"

        exec_log "grep -qxF 'dns=none' /etc/NetworkManager/NetworkManager.conf || printf '\n%s\n%s' '[main]' 'dns=none' | sudo tee -a /etc/NetworkManager/NetworkManager.conf" "${GREEN}[+]${RESET} Adding [${YELLOW}DNS configuration${RESET}] on [${YELLOW}/etc/NetworkManager/NetworkManager.conf${RESET}]"
    fi

    ################################################################
    ##########                    Grub                    ##########
    ################################################################

    if [[ ${packages} =~ "grub/theme.txt" ]]; then
        file_conf="Grub"

        if [[ ${VM} == "none" ]]; then
            exec_log "sudo 7z x -y ${INSTALL_DIRECTORY}/grub/fallout-grub-theme.7z -o/boot/grub/themes" "${GREEN}[+]${RESET} Extracting [${YELLOW}fallout-grub-theme.7z${RESET}] on [${YELLOW}${CURRENT_USER^^} /boot/grub/themes${RESET}] folder"
            exec_log "sudo sed -i 's/GRUB_THEME=\"\/boot\/grub\/themes\/Vimix\/theme.txt\"/GRUB_THEME=\"\/boot\/grub\/themes\/fallout\/theme.txt\"/' /etc/default/grub" "${GREEN}[+]${RESET} Changing [${YELLOW}GRUB${RESET}] theme for [${YELLOW}${CURRENT_USER^^}${RESET}] user (on virtual machine)"
        fi
        exec_log "sudo sed -i 's/quiet //' /etc/default/grub" "${GREEN}[+]${RESET} Configuring [${YELLOW}GRUB${RESET}] : non quiet boot for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        exec_log "sudo sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' /etc/default/grub" "${GREEN}[+]${RESET} Configuring [${YELLOW}GRUB${RESET}] : GRUB_DEFAULT=saved for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        exec_log "sudo sed -i 's/#GRUB_SAVEDEFAULT=\"true\"/GRUB_SAVEDEFAULT=\"true\"/' /etc/default/grub" "${GREEN}[+]${RESET} Configuring [${YELLOW}GRUB${RESET}] : GRUB_SAVEDEFAULT=\"true\" for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        exec_log "sudo sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=${CURRENT_RESOLUTION}/' /etc/default/grub" "${GREEN}[+]${RESET} Configuring [${YELLOW}GRUB${RESET}] : GRUB_GFXMODE=${CURRENT_RESOLUTION} for [${YELLOW}${CURRENT_USER^^}${RESET}] user"

        exec_log "sudo grub-mkconfig -o /boot/grub/grub.cfg" "${GREEN}[+]${RESET} Saving [${YELLOW}GRUB${RESET}] config."
    fi

    ################################################################
    ##########                   Plank                    ##########
    ################################################################

    if [[ ${packages} =~ "plank/*" ]]; then
        file_conf="Plank"

        if ! pacman -Q plank &> /dev/null; then
            exec_log "sudo pacman -S --noconfirm --needed plank" "${GREEN}[+]${RESET} Installing [${YELLOW}Plank${RESET}]"
        fi

        replace_username "${HOME}/.config/plank/dock1/launchers/mediaHuman.YouTubeDownloader.dockitem" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        replace_username "${HOME}/.config/plank/dock1/launchers/arcolinux-settings-in-VSCodium.dockitem" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"

        check_dir ${HOME}/.local/share/applications "user"
        exec_log "sudo cp ${INSTALL_DIRECTORY}/vscodium/arcolinux-settings-in-VSCodium.desktop ${HOME}/.local/share/applications" "${GREEN}[+]${RESET} Copying [${YELLOW}arcolinux-settings-in-VSCodium.desktop${RESET}] file to [${YELLOW}${HOME}/.local/share/applications${RESET}] folder"
        replace_username "${HOME}/.local/share/applications/arcolinux-settings-in-VSCodium.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}arcolinux-settings-in-VSCodium.desktop${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        if [[ ${VM} == "none" ]]; then
            exec_log "sed -i 's/Documents\/arcolinux-settings/Documents\/[Nextcloud]\/[Linux]\/[Scripts]\/arcolinux-settings/' ${HOME}/.local/share/applications/arcolinux-settings-in-VSCodium.desktop" "${GREEN}[+]${RESET} Configuring [${YELLOW}arcolinux-settings-in-VSCodium.desktop${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        fi

        {
            for ((i = 0 ; i <= 100 ; i+=5)); do
                sleep 0.1
                printf "%s\n" "${i}"
            done
        } | whiptail --gauge "Please wait for 3 seconds..." 8 50 0

        if [[ ${VM} == "none" ]]; then
            exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ dock-items \"['xfce4-terminal.dockitem', 'thunar.dockitem', 'brave-browser.dockitem', 'org.mozilla.Thunderbird.dockitem', 'codium.dockitem', 'arcolinux-settings-in-VSCodium.dockitem', 'mediaHuman.YouTubeDownloader.dockitem', 'virtualbox.dockitem']\""  "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] shortcuts for [${YELLOW}${USER^^}${RESET}] user"
        else
            exec_log "rm -v ${HOME}/.config/plank/dock1/launchers/virtualbox.dockitem" "${RED}[-]${RESET} Removing [${YELLOW}virtualbox.dockitem${RESET}]"
            exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ dock-items \"['xfce4-terminal.dockitem', 'thunar.dockitem', 'brave-browser.dockitem', 'org.mozilla.Thunderbird.dockitem', 'codium.dockitem', 'arcolinux-settings-in-VSCodium.dockitem', 'mediaHuman.YouTubeDownloader.dockitem']\"" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] shortcuts for [${YELLOW}${USER^^}${RESET}] user"
        fi
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ hide-delay 300" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] hide-delay: [${YELLOW}300${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ hide-mode auto" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] hide-mode: [${YELLOW}Auto${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ lock-items true" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] lock-items: [${YELLOW}True${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ pinned-only true" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] pinned-only: [${YELLOW}True${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ position top" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] position: [${YELLOW}Top${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme Transparent" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] theme: [${YELLOW}Transparent${RESET}]"
    fi

    ################################################################
    ##########                     QT                     ##########
    ################################################################

    if [[ ${packages} =~ "qt5ct/qt5ct.conf" ]]; then
        file_conf="QT5CT"

        if ! pacman -Q qt5ct &> /dev/null; then
            exec_log "sudo pacman -S --noconfirm --needed qt5ct" "${GREEN}[+]${RESET} Installing [${YELLOW}qt5ct${RESET}] for [${YELLOW}dark theme${RESET}] on Qt applications"
        fi

        if pacman -Q kvantum &> /dev/null; then
            exec_log "sudo pacman -Rsn --noconfirm kvantum" "${RED}[-]${RESET} Unstalling [${YELLOW}kvantum${RESET}]"
        fi

        exec_log "sudo sed -i 's/QT_STYLE_OVERRIDE=kvantum/#QT_STYLE_OVERRIDE=kvantum/' /etc/environment" "${GREEN}[+]${RESET} Remove [${YELLOW}QT_STYLE_OVERRIDE${RESET}] value on [${YELLOW}etc/environment${RESET}] file"
    fi

    ################################################################
    ##########                    SDDM                    ##########
    ################################################################

    if [[ ${packages} =~ "sddm/kde_settings.conf" ]]; then
        file_conf="SDDM"

        check_dir /usr/share/sddm/themes/arcolinux-sugar-candy "root"

        if [ -z "$(ls -A /usr/share/sddm/themes/arcolinux-sugar-candy)" ]; then
            exec_log "sudo pacman -S --noconfirm --needed arcolinux-sddm-sugar-candy-git" "${GREEN}[+]${RESET} Installing [${YELLOW}Sugar candy SDDM${RESET}] theme"
        fi

        exec_log "sudo cp -a ${INSTALL_DIRECTORY}/sddm/theme.conf /usr/share/sddm/themes/arcolinux-sugar-candy" "${GREEN}[+]${RESET} Copying [${YELLOW}theme.conf${RESET}] to [${YELLOW}/usr/share/sddm/themes/arcolinux-sugar-candy${RESET}]"
        if [[ ! ${VM} == "none" ]]; then
            exec_log "sudo sed -i 's/Mountain.jpg/background.jpg/' /usr/share/sddm/themes/arcolinux-sugar-candy/theme.conf" "${GREEN}[+]${RESET} Changing [${YELLOW}SDDM${RESET}] background for [${YELLOW}${CURRENT_USER^^}${RESET}] user (on virtual machine)"
            exec_log "sudo sed -i 's/Bienvenue !/⚠ MACHINE VIRTUELLE ⚠/' /usr/share/sddm/themes/arcolinux-sugar-candy/theme.conf" "${GREEN}[+]${RESET} Changing [${YELLOW}SDDM${RESET}] welcome message for [${YELLOW}${CURRENT_USER^^}${RESET}] user (on virtual machine)"
        fi
    fi

    ################################################################
    ##########            XFCE - Theme & icons            ##########
    ################################################################

    if [[ ${packages} =~ "xfce/*" ]]; then
        file_conf="XFCE"

        exec_log "sudo 7z x -y ${INSTALL_DIRECTORY}/themes/Windows-10-Dark-3.2.1-dark.7z -o/usr/share/themes" "${GREEN}[+]${RESET} Extracting [${YELLOW}Windows-10-Dark-3.2.1-dark.7z${RESET}] theme"
        exec_log "sudo 7z x -y ${INSTALL_DIRECTORY}/icons/Mint-L-Yellow-We10x-black-dark.7z -o/usr/share/icons" "${GREEN}[+]${RESET} Extracting [${YELLOW}Mint-L-Yellow-We10x-black-dark.7z${RESET}] icons"
    fi

    ################################################################
    ##########                     ZSH                    ##########
    ################################################################

    if [[ ${packages} =~ "shell/.zshrc" ]]; then
        file_conf="ZSH"

        exec_log "sudo pacman -S --noconfirm --needed oh-my-zsh-powerline-theme-git" "${GREEN}[+]${RESET} Installing [${YELLOW}Oh-my-zsh Powerline${RESET}] theme"

        check_dir ${HOME}/.config/zsh "user"
        exec_log "sudo sed -i 's/\${ZDOTDIR:-\$HOME}/\${ZDOTDIR:-\$HOME\/.config\/zsh}/' /usr/share/oh-my-zsh/oh-my-zsh.sh" "${GREEN}[+]${RESET} Changing path for[${YELLOW}ZSH cache completion${RESET}] on [${YELLOW}/usr/share/oh-my-zsh/oh-my-zsh.sh${RESET}]"
        exec_log "sudo cp ${INSTALL_DIRECTORY}/pacman.hook/edit-zdotdir.hook /etc/pacman.d/hooks" "${GREEN}[+]${RESET} Copying [${YELLOW}edit-zdotdir.hook${RESET}] file to [${YELLOW}/etc/pacman.d/hooks${RESET}] folder"

        exec_log "sudo chsh -s /bin/zsh ${CURRENT_USER}" "${GREEN}[+]${RESET} Setting default [${YELLOW}shell${RESET}] to [${YELLOW}ZSH${RESET}]"
    fi
}