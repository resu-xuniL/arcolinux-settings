#!/bin/bash
#set -e
##################################################################################################################
# Author    : Wam
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

INSTALL_DIRECTORY=$(dirname $(readlink -f $(basename `pwd`)))
CURRENT_USER=$(whoami)
CURRENT_RESOLUTION=$(xdpyinfo | grep dimensions: | awk '{print $2}')

##################################################################################################################

tput setaf 3
echo "################################################################"
echo "############## Change permissions on config. files #############"
echo "################################################################"
tput sgr0
echo
find $INSTALL_DIRECTORY/settings -type f -exec chmod 644 -- {} +

tput setaf 3
echo "################################################################"
echo "################# Create personal directories ##################"
echo "################################################################"
tput sgr0
echo
[ -d $HOME/.config ] || mkdir -p $HOME/.config
[ -d $HOME/Documents/[Nextcloud] ] || mkdir -p $HOME/Documents/[Nextcloud]

if grep -q "ArcoLinux" /etc/os-release; then

    echo
    tput setaf 3
    echo "################################################################"
    echo "################# Personal settings to install #################"
    echo "################################################################"
    tput sgr0


    if [[ ! $CURRENT_USER = "wam" ]];then
    	echo
        tput setaf 2
        echo "################################################################"
        echo "#### Giving permission for VM shared folder (guest machine) ####"
        echo "################################################################"
        tput sgr0
        echo
	    sudo usermod -aG vboxsf $USER
    fi

	echo
    tput setaf 2
    echo "################################################################"
    echo "############### Installing personal aliases ####################"
    echo "################################################################"
    tput sgr0
	echo
	cp $INSTALL_DIRECTORY/settings/shell/.bashrc-personal ~/.bashrc-personal


  	echo
    tput setaf 2
    echo "################################################################"
    echo "################## Adjust clock for dual-boot ##################"
    echo "################################################################"
    tput sgr0
    echo
	sudo timedatectl set-local-rtc 1 --adjust-system-clock

  	echo
    tput setaf 2
    echo "################################################################"
    echo "################ Disable "^[[200~" on terminal #################"
    echo "################################################################"
    tput sgr0
    echo
	cp $INSTALL_DIRECTORY/settings/terminal/.inputrc ~/.inputrc

  	echo
    tput setaf 2
    echo "################################################################"
    echo "########################## Set DNS #############################"
    echo "################################################################"
    tput sgr0
    echo
	sudo cp -a $INSTALL_DIRECTORY/settings/dns/resolv.conf /etc

  	echo
    tput setaf 2
    echo "################################################################"
    echo "############### Set settings for filenames order ###############"
    echo "################################################################"
    tput sgr0
    echo
	sudo localectl set-locale LC_COLLATE=C
    gsettings set org.gtk.Settings.FileChooser sort-directories-first true

  	echo
    tput setaf 2
    echo "################################################################"
    echo "############################ Conky #############################"
    echo "################################################################"
    tput sgr0
    echo
	[ -d $HOME/.config/conky ] || mkdir -p $HOME/.config/conky
    cp $INSTALL_DIRECTORY/settings/conky/JA-Phone.conkyrc $HOME/.config/conky
    
    if [ ! $CURRENT_RESOLUTION = "1680x1050" ];then
        echo "Configuring for LAPTOP"
        sed -i "s/1300/1010/" $HOME/.config/conky/JA-Phone.conkyrc
        sed -i "s/750/480/" $HOME/.config/conky/JA-Phone.conkyrc
    fi

    echo "Configuring for ${CURRENT_USER^^} user"
    cp $INSTALL_DIRECTORY/settings/conky/conky-sessionfile $HOME/.config/conky/
    sed -i "s/\*\*\*/$CURRENT_USER/" $HOME/.config/conky/conky-sessionfile

	echo
    tput setaf 2
    echo "################################################################"
    echo "############################ Grub ##############################"
    echo "################################################################"
    tput sgr0
    echo
    sudo cp -a $INSTALL_DIRECTORY/settings/grub/theme.txt /boot/grub/themes/Vimix/

    echo "Configuring for ${CURRENT_USER^^} user"
    if [[ ! $CURRENT_USER = "wam" ]];then
        sudo sed -i "s/archlinux03.jpg/archlinux04.jpg/" /boot/grub/themes/Vimix/theme.txt
    fi
    sudo sed -i "s/quiet //" /etc/default/grub

    sudo grub-mkconfig -o /boot/grub/grub.cfg

	echo
    tput setaf 2
    echo "################################################################"
    echo "########################### GTK-3.0 ############################"
    echo "####################### (theme & icons) ########################"
    echo "################################################################"
    tput sgr0
    echo
	[ -d $HOME/.config/gtk-3.0 ] || mkdir -p $HOME/.config/gtk-3.0
	cp $INSTALL_DIRECTORY/settings/gtk3/settings.ini $HOME/.config/gtk-3.0

	echo
    tput setaf 2
    echo "################################################################"
    echo "############################ Plank #############################"
    echo "################################################################"
    tput sgr0
    echo
    [ -d $HOME/.config/plank/dock1/ ] || mkdir -p $HOME/.config/plank/dock1/
	[ -d $HOME/.config/plank/dock1/launchers/ ] || mkdir -p $HOME/.config/plank/dock1/launchers/
	    
    cp "$INSTALL_DIRECTORY/settings/plank/"* $HOME/.config/plank/dock1/launchers

    echo "Configuring for ${CURRENT_USER^^} user"
    sed -i "s/\*\*\*/$CURRENT_USER/" $HOME/.config/plank/dock1/launchers/mediaHuman.YouTubeDownloader.dockitem
    
    secs=$((3))
    while [ $secs -gt 0 ]; do
        echo -ne "Patientez : $secs\033[0K\r"
        sleep 1
        : $((secs--))
    done

    if [[ $CURRENT_USER = "wam" ]];then
        gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ dock-items "['xfce4-terminal.dockitem', 'thunar.dockitem', 'brave-browser.dockitem', 'org.mozilla.Thunderbird.dockitem', 'MediaHuman YouTube Downloader.dockitem', 'virtualbox.dockitem']"
    else
        rm -v $HOME/.config/plank/dock1/launchers/virtualbox.dockitem
        gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ dock-items "['xfce4-terminal.dockitem', 'thunar.dockitem', 'brave-browser.dockitem', 'org.mozilla.Thunderbird.dockitem', 'MediaHuman YouTube Downloader.dockitem']"
    fi
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ hide-delay 300
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ hide-mode auto
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ lock-items true
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ pinned-only true
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ position top
    gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme Transparent

    echo -ne "Done \033[0K\r"

	echo
    tput setaf 2
    echo "################################################################"
    echo "############################ Samba #############################"
    echo "################################################################"
    tput sgr0
    echo
	[ -d /etc/samba ] || sudo mkdir -p /etc/samba
	sudo cp -a $INSTALL_DIRECTORY/settings/samba/smb.conf /etc/samba

  	echo
    tput setaf 2
    echo "################################################################"
    echo "############################# SDDM #############################"
    echo "################################################################"
    tput sgr0
    echo
	[ -d /usr/share/sddm/themes/arcolinux-sugar-candy ] || sudo mkdir -p /usr/share/sddm/themes/arcolinux-sugar-candy
    [ -d /etc/sddm.conf.d/ ] || sudo mkdir -p /etc/sddm.conf.d/
    sudo cp -a $INSTALL_DIRECTORY/settings/sddm/theme.conf /usr/share/sddm/themes/arcolinux-sugar-candy
	sudo cp -a $INSTALL_DIRECTORY/settings/sddm/kde_settings.conf /etc/sddm.conf.d

    if [[ ! $CURRENT_USER = "wam" ]];then
        echo "Changing background for ${CURRENT_USER^^} user"
        sudo sed -i "s/Mountain.jpg/background.jpg/" /usr/share/sddm/themes/arcolinux-sugar-candy/theme.conf
        sudo sed -i "s/Bienvenue !/⚠ MACHINE VIRTUELLE ⚠/" /usr/share/sddm/themes/arcolinux-sugar-candy/theme.conf        
    fi

	echo
    tput setaf 2
    echo "################################################################"
    echo "################## Thunar (Personal actions) ###################"
    echo "################################################################"
    tput sgr0
    echo
	[ -d $HOME/.config/Thunar ] || mkdir -p $HOME/.config/Thunar
	cp $INSTALL_DIRECTORY/settings/thunar/uca.xml $HOME/.config/Thunar

	echo
    tput setaf 2
    echo "################################################################"
    echo "########################### Variety ############################"
    echo "################################################################"
    tput sgr0
    echo
	[ -d $HOME/.config/variety ] || mkdir -p $HOME/.config/variety
	cp $INSTALL_DIRECTORY/settings/variety/variety.conf ~/.config/variety/

    tput setaf 2
    echo "################################################################"
    echo "############### VLC : Enable pause-click plug-in ###############"
    echo "################################################################"
    tput sgr0
    echo
	[ -d $HOME/.config/vlc ] || mkdir -p $HOME/.config/vlc
	cp $INSTALL_DIRECTORY/settings/vlc/vlcrc $HOME/.config/vlc

	echo
    tput setaf 2
    echo "################################################################"
    echo "############ Wine :  Mediahuman Youtube downloader #############"
    echo "################################################################"
    tput sgr0
    echo
    [ -d $HOME/.wine/drive_c/users/$CURRENT_USER/AppData/Local/MediaHuman/YouTube\ Downloader ] || mkdir -p $HOME/.wine/drive_c/users/$CURRENT_USER/AppData/Local/MediaHuman/YouTube\ Downloader

    if [[ $CURRENT_RESOLUTION = "1680x1050" && $CURRENT_USER = "wam" ]];then
        ln -s /mnt/WinArium/Users/${CURRENT_USER^}/AppData/Local/MediaHuman/YouTube\ Downloader $HOME/.wine/drive_c/users/$CURRENT_USER/AppData/Local/MediaHuman/YouTube\ Downloader
    else
        if [[ $CURRENT_USER = "wam" ]];then
            cp $INSTALL_DIRECTORY/settings/wine/youtube-downloader/$CURRENT_USER-user/tracking.dat $HOME/.wine/drive_c/users/$CURRENT_USER/AppData/Local/MediaHuman/YouTube\ Downloader
        else
            cp $INSTALL_DIRECTORY/settings/wine/youtube-downloader/tracking.dat $HOME/.wine/drive_c/users/$CURRENT_USER/AppData/Local/MediaHuman/YouTube\ Downloader
        fi
    fi

	echo
    tput setaf 2
    echo "################################################################"
    echo "######################## XFCE settings #########################"
    echo "############ Keyboard shortcut - Thunar - Terminal #############"
    echo "################################################################"
    tput sgr0
    echo
	[ -d $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/ ] || mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
	cp "$INSTALL_DIRECTORY/settings/xfce/"* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml

    echo
    tput setaf 2
    echo "################################################################"
    echo "#################### Personal settings done ####################"
    echo "################################################################"
    tput sgr0
    echo
fi

echo
echo "VirtualBox check - copy/paste template or not"
echo

result=$(systemd-detect-virt)
if [ $result = "none" ];then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################# Copy-paste VirtualBox template ###############"
	echo "################################################################"
	tput sgr0
	echo	

	[ -d $HOME/VirtualBox\ VMs ] || mkdir -p $HOME/VirtualBox\ VMs
	cp settings/virtualbox-template/template.tar.gz ~/VirtualBox\ VMs/
	cd ~/VirtualBox\ VMs/
	tar -xzf template.tar.gz
	rm -f template.tar.gz	

else

	echo
	tput setaf 1
	echo "################################################################"
    echo "######                                                    ######"
	echo "###### You are on a virtual machine - skipping VirtualBox ######"
    echo "######                                                    ######"
	echo "######              Template is NOT copied                ######"
    echo "######                                                    ######"
	echo "################################################################"
	tput sgr0
	echo
fi

tput setaf 3
echo "################################################################"
echo "################ PERSONAL SETTINGS COMPLETE ! ##################"
echo "################################################################"
tput sgr0
echo
