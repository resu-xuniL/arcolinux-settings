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

##################################################################################################################

echo
tput setaf 3
echo "################################################################"
echo "################### Installation & settings ####################"
echo "################################################################"
tput sgr0
echo

while [[ $REPLY != 0 ]]; do
    clear
    cat <<- _EOF_
    Please Select:

    1. Install bookmarks for WAMVM user
    2. Install bookmarks for WAM user
    3. Install bookmarks for WAM user with dual-boot
    0. Cancel

_EOF_

    read -p "Enter selection [0-3] > " -n 1 -r selection
    tput cup 8 0

    case $selection in
    1)  
        echo
        tput setaf 3
        echo "################################################################"
        echo "#################### Installing Bookmarks ######################"
        echo "################################################################"
        tput sgr0
        echo

        [ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
        cp $INSTALL_DIRECTORY/settings/gtk3/bookmarks/wamvm_user/bookmarks ~/.config/gtk-3.0/

        tput setaf 3
        echo "################################################################"
        echo "################# PERSONAL BOOKMARKS ADDED ! ###################"
        echo "################################################################"
        tput sgr0
        echo
        break
        ;;
    2)  
        echo
        tput setaf 3
        echo "################################################################"
        echo "#################### Installing Bookmarks ######################"
        echo "################################################################"
        tput sgr0
        echo

        [ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
        cp $INSTALL_DIRECTORY/settings/gtk3/bookmarks/wam_user/bookmarks ~/.config/gtk-3.0/

        tput setaf 3
        echo "################################################################"
        echo "################# PERSONAL BOOKMARKS ADDED ! ###################"
        echo "################################################################"
        tput sgr0
        echo
		break
        ;; 
    3)  
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
        echo "#################### Installing Bookmarks ######################"
        echo "################################################################"
        tput sgr0
        echo

        [ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
        cp $INSTALL_DIRECTORY/settings/gtk3/bookmarks/wam_user/dual-boot/bookmarks ~/.config/gtk-3.0/

        tput setaf 3
        echo "################################################################"
        echo "################# PERSONAL BOOKMARKS ADDED ! ###################"
        echo "################################################################"
        tput sgr0
        echo
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
    echo -e "\r################################################################"
    echo "################## INSTALLATION ABORTED ! ######################"
    echo "################################################################"
    tput sgr0
    echo
    exit 0
else
    sh 100-install-core-software.sh
    sh 110-remove-software.sh
    sh 200-install-personal-settings.sh
    sh 210-autostart-applications.sh

    tput setaf 3
    echo -e "\r################################################################"
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