declare -A root_config_files_list
declare -A user_config_files_list

selected_packages=""

set_config_files_list() {

    root_config_files_list=(
        [Set 1.1.1.1 DNS]="dns/resolv.conf /etc"
        [GRUB : Change theme and edit settings]="grub/theme.txt /boot/grub/themes/Vimix"
        [Samba : Edit config.]="samba/smb.conf /etc/samba"
        [SDDM : Enable arcolinux-sugar-candy theme]="sddm/kde_settings.conf /etc/sddm.conf.d"
    )

    user_config_files_list=(
        [Autostart applications]="autostart/* ${HOME}/.config/autostart"
        [Thunar : bookmarks]="gtk3/bookmarks ${HOME}/.config/gtk-3.0"
        [Thunar : Personal actions]="thunar/uca.xml ${HOME}/.config/Thunar"
        [Personal aliases for BASH]="shell/.bashrc-personal ${HOME}"
        [Personal aliases for ZSH]="shell/.zshrc-personal ${HOME}"
        [Shell : ZSH (with powerline theme)]="terminal/xfce4-terminal.xml ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml"
        [Disable \"^\[\[200~\" on terminal]="terminal/.inputrc ${HOME}"
        [Conky : Conky WAM & USER config. and alias]="conky/conky-sessionfile ${HOME}/.config/conky"
        [GTK-3.0 : Theme & icons]="gtk3/settings.ini ${HOME}/.config/gtk-3.0"
        [Variety]="variety/variety.conf ${HOME}/.config/variety"
        [VLC : Enable pause-click plug-in]="vlc/vlcrc ${HOME}/.config/vlc"
        [VLC : Customize interface]="vlc/vlc-qt-interface.conf ${HOME}/.config/vlc"
        [Plank]="plank/* ${HOME}/.config/plank/dock1/launchers"
        [XFCE settings : Keyboard shortcut - Thunar config - Theme - Icons]="xfce/* ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml"
        [VSCode settings]="vscode/settings.json ${HOME}/.config/Code/User"
        [VSCode snippets]="vscode/shellscript.json ${HOME}/.config/Code/User/snippets"
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
            exec_log "printf '%s\n' 'file:///home/***/VirtualBox_VMs/_SharedFolder VM shared folder' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}VM shared folder${RESET}] bookmark"
            
            if [[ ${CURRENT_RESOLUTION} == "1680x1050" ]]; then
                exec_log "printf '%s\n' 'file:///mnt/Swap%20%5B511%20Go%5D/%5BFilms%5D' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}[Films]${RESET}] bookmark"
                exec_log "printf '%s\n' 'file:///mnt/Swap%20%5B511%20Go%5D/%5BVU%5D' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}[VU]${RESET}] bookmark"
                exec_log "printf '%s\n' 'file:///mnt/Storage%20%5B200%20Go%5D/Tools/%5BLinux%5D/%5BVideos%5D [Storage : Linux Videos]' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}[Storage : Linux Videos]${RESET}] bookmark"
                exec_log "printf '%s\n' 'file:///home/***/.wine/drive_c [Wine drive C :\]' >> ${HOME}/.config/gtk-3.0/bookmarks" "${GREEN}[+]${RESET} Adding [${YELLOW}[Wine drive C :\]${RESET}] bookmark"

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
    fi
        
    ################################################################
    ##########                   Conky                    ##########
    ################################################################

    if [[ ${packages} =~ "conky/conky-sessionfile" ]]; then
        file_conf="Conky"

        check_dir ${HOME}/.cache/openmeteo "user"

        exec_log "sudo cp -a ${INSTALL_DIRECTORY}/fonts/Bentoh_mod.ttf /usr/share/fonts/TTF" "${GREEN}[+]${RESET} Copying [${YELLOW}Bentoh_mod.ttf${RESET}] font to [${YELLOW}/usr/share/fonts/TTF${RESET}]"
        exec_log "sudo cp -a ${INSTALL_DIRECTORY}/fonts/Rallifornia.ttf /usr/share/fonts/TTF" "${GREEN}[+]${RESET} Copying [${YELLOW}Rallifornia.ttf${RESET}] font to [${YELLOW}/usr/share/fonts/TTF${RESET}]"
        exec_log "sudo cp -a ${INSTALL_DIRECTORY}/fonts/Californication.ttf /usr/share/fonts/TTF" "${GREEN}[+]${RESET} Copying [${YELLOW}Californication.ttf${RESET}] font to [${YELLOW}/usr/share/fonts/TTF${RESET}]"
        exec_log "sudo fc-cache -fv" "${GREEN}[+]${RESET} Building [${YELLOW}fonts${RESET}] cache file"

        fetch_password
        exec_log "7z x -p${PASSWORD} -y ${INSTALL_DIRECTORY}/conky/meteo-icons.7z -o${HOME}/.config/conky/images" "${GREEN}[+]${RESET} Extracting [${YELLOW}meteo-icons.7z${RESET}] to [${YELLOW}${HOME}/.config/conky/images/meteo-icons${RESET}]"
      
        exec_log "cp ${INSTALL_DIRECTORY}/conky/WAM.conkyrc ${HOME}/.config/conky" "${GREEN}[+]${RESET} Copying [${YELLOW}WAM.conkyrc${RESET}] file to [${YELLOW}${HOME}/.config/conky${RESET}] folder"
        exec_log "cp ${INSTALL_DIRECTORY}/conky/wam_fetch_icon.sh ${HOME}/.config/conky" "${GREEN}[+]${RESET} Copying [${YELLOW}wam_fetch_icon.sh${RESET}] file to [${YELLOW}${HOME}/.config/conky${RESET}] folder"
        exec_log "cp ${INSTALL_DIRECTORY}/conky/wam_color_switch.sh ${HOME}/.config/conky" "${GREEN}[+]${RESET} Copying [${YELLOW}wam_color_switch.sh${RESET}] file to [${YELLOW}${HOME}/.config/conky${RESET}] folder"
        exec_log "grep -qxF '# Switch conky colors' ${HOME}/.bashrc-personal || printf '\n%s\n%s\n' '# Switch conky colors' 'alias conky-switch=\". ~/.config/conky/wam_color_switch.sh\"' | sudo tee -a ${HOME}/.bashrc-personal" "${GREEN}[+]${RESET} Adding [${YELLOW}conky-switch alias${RESET}] to [${YELLOW}${HOME}/.bashrc-personal${RESET}]"
        exec_log "grep -qxF '# Switch conky colors' ${HOME}/.zshrc-personal || printf '\n%s\n%s\n' '# Switch conky colors' 'alias conky-switch=\". ~/.config/conky/wam_color_switch.sh\"' | sudo tee -a ${HOME}/.zshrc-personal" "${GREEN}[+]${RESET} Adding [${YELLOW}conky-switch alias${RESET}] to [${YELLOW}${HOME}/.zshrc-personal${RESET}]"

        replace_username "${HOME}/.config/conky/conky-sessionfile" "${GREEN}[+]${RESET} Configuring [${YELLOW}conky-sessionfile${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
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

        if [[ ! ${CURRENT_USER} == "wam" ]]; then
            exec_log "sudo sed -i 's/archlinux03.jpg/archlinux04.jpg/' /boot/grub/themes/Vimix/theme.txt" "${GREEN}[+]${RESET} Changing [${YELLOW}GRUB${RESET}] theme for [${YELLOW}${CURRENT_USER^^}${RESET}] user (on virtual machine)"
        fi
        exec_log "sudo sed -i 's/quiet //' /etc/default/grub" "${GREEN}[+]${RESET} Configuring [${YELLOW}GRUB${RESET}] : quiet boot for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        exec_log "sudo sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' /etc/default/grub" "${GREEN}[+]${RESET} Configuring [${YELLOW}GRUB${RESET}] : GRUB_DEFAULT=saved for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        exec_log "sudo sed -i 's/#GRUB_SAVEDEFAULT=\"true\"/GRUB_SAVEDEFAULT=\"true\"/' /etc/default/grub" "${GREEN}[+]${RESET} Configuring [${YELLOW}GRUB${RESET}] : GRUB_SAVEDEFAULT=\"true\" for [${YELLOW}${CURRENT_USER^^}${RESET}] user"

        exec_log "sudo grub-mkconfig -o /boot/grub/grub.cfg" "${GREEN}[+]${RESET} Saving [${YELLOW}GRUB${RESET}] config."
    fi

    ################################################################
    ##########                   Plank                    ##########
    ################################################################

    if [[ ${packages} =~ "plank/*" ]]; then
        file_conf="Plank"

        replace_username "${HOME}/.config/plank/dock1/launchers/mediaHuman.YouTubeDownloader.dockitem" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] for [${YELLOW}${CURRENT_USER^^}${RESET}] user"
        
        {
            for ((i = 0 ; i <= 100 ; i+=5)); do
                sleep 0.1
                printf "%s\n" "${i}"
            done
        } | whiptail --gauge "Please wait for 3 seconds..." 8 50 0

        if [[ ${CURRENT_USER} == "wam" ]]; then
            exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ dock-items \"['xfce4-terminal.dockitem', 'thunar.dockitem', 'brave-browser.dockitem', 'org.mozilla.Thunderbird.dockitem', 'MediaHuman YouTube Downloader.dockitem', 'virtualbox.dockitem', 'code.dockitem']\""  "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] shortcuts for [${YELLOW}${USER^^}${RESET}] user"
        else
            exec_log "rm -v ${HOME}/.config/plank/dock1/launchers/virtualbox.dockitem" "${RED}[-]${RESET} Removing [${YELLOW}virtualbox.dockitem${RESET}]"
            exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ dock-items \"['xfce4-terminal.dockitem', 'thunar.dockitem', 'brave-browser.dockitem', 'org.mozilla.Thunderbird.dockitem', 'MediaHuman YouTube Downloader.dockitem', 'code.dockitem']\"" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] shortcuts for [${YELLOW}${USER^^}${RESET}] user"
        fi
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ hide-delay 300" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] hide-delay: [${YELLOW}300${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ hide-mode auto" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] hide-mode: [${YELLOW}Auto${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ lock-items true" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] lock-items: [${YELLOW}True${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ pinned-only true" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] pinned-only: [${YELLOW}True${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ position top" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] position: [${YELLOW}Top${RESET}]"
        exec_log "gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme Transparent" "${GREEN}[+]${RESET} Configuring [${YELLOW}Plank${RESET}] theme: [${YELLOW}Transparent${RESET}]"
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

    if [[ ${packages} =~ "terminal/xfce4-terminal.xml" ]]; then
        file_conf="ZSH"

        exec_log "sudo pacman -S --noconfirm --needed oh-my-zsh-powerline-theme-git" "${GREEN}[+]${RESET} Installing [${YELLOW}Oh-my-zsh Powerline${RESET}] theme"
        
        exec_log "sed -i 's/# ZSH_THEME_RANDOM_CANDIDATES=( \"robbyrussell\" \"agnoster\" )/ZSH_THEME_RANDOM_CANDIDATES=( \"powerline\" \"xiong-chiamiov-plus\" )/' ${HOME}/.zshrc" "${GREEN}[+]${RESET} Setting [${YELLOW}random themes${RESET}] to [${YELLOW}ZSH shell${RESET}]"

        check_dir ${HOME}/.config/zsh "user"
        exec_log "sudo sed -i 's/\${ZDOTDIR:-\$HOME}/\${ZDOTDIR:-\$HOME\/.config\/zsh}/' /usr/share/oh-my-zsh/oh-my-zsh.sh" "${GREEN}[+]${RESET} Changing path for[${YELLOW}ZSH cache completion${RESET}] on [${YELLOW}/usr/share/oh-my-zsh/oh-my-zsh.sh${RESET}]"
    fi
}