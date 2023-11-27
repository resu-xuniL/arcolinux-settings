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
VM=$(systemd-detect-virt)

##################################################################################################################

echo
tput setaf 3
echo "################################################################"
echo "################### Installation & settings ####################"
echo "################################################################"
tput sgr0
echo
[ -d $HOME/.config/gtk-3.0 ] || mkdir -p $HOME/.config/gtk-3.0
cp $INSTALL_DIRECTORY/settings/gtk3/bookmarks ~/.config/gtk-3.0/
if [ $VM = "none" ];then
    echo "file:///home/***/VirtualBox%20VMs/_SharedFolder VM shared folder" >> ~/.config/gtk-3.0/bookmarks
fi
sed -i "s/\*\*\*/$CURRENT_USER/" ~/.config/gtk-3.0/bookmarks

while [[ $REPLY != 0 ]]; do
    clear
    cat <<- _EOF_
    Please Select:

    1. Normal
    2. Dual-boot
    0. Abort

_EOF_

    read -p "Enter selection [0-2] > " -n 1 -r selection
    tput cup 8 0

    case $selection in
    1)  
        tput setaf 3
        echo "################################################################"
        echo "################# PERSONAL BOOKMARKS ADDED ! ###################"
        echo "################################################################"
        tput sgr0
        echo
		break
        ;; 
    2)  
        if [[ $CURRENT_RESOLUTION = "1680x1050" && $VM = "none" ]];then
            echo
            tput setaf 3
            echo "################################################################"
            echo "####### Setting auto-mount for other (NTFS) partitions #########"
            echo "################################################################"
            tput sgr0
            echo
            sudo cp -a $INSTALL_DIRECTORY/settings/automount/fstab /etc

            tput setaf 3
            echo "################################################################"
            echo "##################### Auto-mount done ! ########################"
            echo "################################################################"
            tput sgr0
            echo

            echo
            tput setaf 3
            echo "################################################################"
            echo "################### Adding other bookmarks #####################"
            echo "################################################################"
            tput sgr0
            echo
            echo "file:///mnt/Swap%20%5B511%20Go%5D/%5BVU%5D" >> ~/.config/gtk-3.0/bookmarks
            echo "file:///mnt/Storage%20%5B200%20Go%5D/Tools/%5BLinux%5D/%5BVideos%5D [Storage : Linux Videos]" >> ~/.config/gtk-3.0/bookmarks
            echo "file:///home/***/.wine/drive_c [Wine drive C :\]" >> ~/.config/gtk-3.0/bookmarks
            echo "file:///home/***/VirtualBox%20VMs/_SharedFolder VM shared folder" >> ~/.config/gtk-3.0/bookmarks
            sed -i "s/\*\*\*/$CURRENT_USER/" ~/.config/gtk-3.0/bookmarks
            
            tput setaf 3
            echo "################################################################"
            echo "################# PERSONAL BOOKMARKS ADDED ! ###################"
            echo "################################################################"
            tput sgr0
            echo
        else
            tput setaf 1
            echo "################################################################"
            echo "####### ⚠  WARNING, this is NOT a dual-boot machine ⚠ ########"
            echo "############### AUTO-MOUNT PARTITIONS ABORTED ! ################"
            echo "################# AND NONE BOOKMARK ADDED ! ####################"
            echo "################################################################"
            tput sgr0
            echo
        fi
		break
        ;; 
    0)  
        tput setaf 1; tput bold
        echo "################################################################"
        echo "################## INSTALLATION ABORTED ! ######################"
        echo "################################################################"
        tput sgr0
        echo
        exit 0
        ;;
    *)  
        tput setaf 1
        echo "################################################################"
        echo "################### INVALID SELECTION ! ########################"
        echo "################################################################"
        tput sgr0
        ;;
    esac
    printf "\n\nPress any key to continue."
    read -n 1
done

if [[ $REPLY = 0 ]] ; then
    tput setaf 1; tput bold
    echo "################################################################"
    echo "################## INSTALLATION ABORTED ! ######################"
    echo "################################################################"
    tput sgr0
    echo
    exit 0
else
    sh 110-uninstall-software.sh
    sh 100-install-core-software.sh
    sh 200-install-personal-settings.sh
    sh 210-autostart-applications.sh

    tput setaf 3
    echo "################################################################"
    echo "###########                                          ###########"
    echo "###########                                          ###########"
    echo "###########               ALL DONE !                 ###########"
    echo "###########                                          ###########"
    echo "###########                                          ###########"
    echo "################################################################"
    tput sgr0
    echo

    echo 
    tput setaf 3; tput bold; tput blink
    echo "################################################################"
    echo "#############                                      #############"
    echo "#############       `tput sgr0; tput bold`REBOOTING in 10 seconds`tput setaf 3; tput blink`        #############"
    echo "#############                                      #############"
    echo "#############    `tput sgr0`Press CTRL + C to stop script`tput setaf 3; tput bold ;tput blink`     #############"
    echo "#############                                      #############"
    echo "################################################################"
    tput sgr0
    echo 
    secs=$((10))
    while [ $secs -gt 0 ]; do
        echo -ne "\rPatientez : $secs\033[0K"
        sleep 1
        : $((secs--))
    done
    echo -ne " \rREBOOTING...\033[0K"
    sleep 1
    sudo reboot
fi