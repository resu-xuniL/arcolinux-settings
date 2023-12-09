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

##################################################################################################################

echo
tput setaf 3
echo "################################################################"
echo "###########                                          ###########"
echo "###########             Updating system              ###########"
echo "###########                                          ###########"
echo "################################################################"
tput sgr0
echo
sudo pacman -Syyu --noconfirm

echo
tput setaf 3
echo "################################################################"
echo "###########                                          ###########"
echo "###########             System updated !             ###########"
echo "###########                                          ###########"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 3
echo "################################################################"
echo "###########                                          ###########"
echo "###########          Software Installation           ###########"
echo "###########                                          ###########"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 4
echo "################################################################"
echo "########################### Brave ##############################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed brave-bin

echo
tput setaf 4
echo "################################################################"
echo "######################### Galculator ###########################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed galculator

echo
tput setaf 4
echo "################################################################"
echo "########################## Keepassxc ###########################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed keepassxc

echo
tput setaf 4
echo "################################################################"
echo "############################ Meld ##############################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed meld

echo
tput setaf 4
echo "################################################################"
echo "########################## Nextcloud ###########################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed nextcloud-client

echo
tput setaf 4
echo "################################################################"
echo "###################### Noto fonts - emoji ######################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed noto-fonts-emoji

echo
tput setaf 4
echo "################################################################"
echo "############################ Plank #############################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed plank

echo
tput setaf 4
echo "################################################################"
echo "######################### qBittorrent ##########################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed qbittorrent

echo
tput setaf 4
echo "################################################################"
echo "######################### Thunderbird ##########################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed thunderbird

echo
tput setaf 4
echo "################################################################"
echo "########################### Ventoy #############################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed ventoy-bin

echo
tput setaf 4
echo "################################################################"
echo "########################## Veracrypt ###########################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed veracrypt

echo
tput setaf 4
echo "################################################################"
echo "###################### Visual studio code ######################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed visual-studio-code-bin

echo
tput setaf 4
echo "################################################################"
echo "############################# VLC ##############################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed vlc

echo
tput setaf 4
echo "################################################################"
echo "################# VLC pause on click plug-in ###################"
echo "################################################################"
tput sgr0
echo
sudo pacman -U --noconfirm --needed $INSTALL_DIRECTORY/settings/vlc/vlc-pause-click-plugin-2.2.0-1-x86_64.pkg.tar.zst
echo

echo
tput setaf 4
echo "################################################################"
echo "####################### we10x icon theme #######################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed we10x-icon-theme-git

echo
tput setaf 4
echo "################################################################"
echo "############################# Wine #############################"
echo "################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed wine

echo
tput setaf 4
echo "################################################################"
echo "####################### Wine : Shortcut ########################"
echo "################################################################"
tput sgr0
echo
[ -d $HOME"/.wine/drive_c/windows" ] || mkdir -p $HOME"/.wine/drive_c/windows"
cp $INSTALL_DIRECTORY/settings/wine/shortcut/shortcut.exe $HOME/.wine/drive_c/windows

echo
tput setaf 4
echo "################################################################"
echo "###################### Wine : Tag renamer ######################"
echo "################################################################"
tput sgr0
echo
[ -d $HOME/.wine/drive_c/Program\ Files/TagRename ] || mkdir -p $HOME/.wine/drive_c/Program\ Files/TagRename
7z x $INSTALL_DIRECTORY/settings/wine/tag-rename/TagRename.7z -o$HOME/.wine/drive_c/Program\ Files/TagRename

[ -d $HOME/.wine/drive_c/ProgramData/Microsoft/Windows/Start\ Menu/Programs/TagRename ] || mkdir -p $HOME/.wine/drive_c/ProgramData/Microsoft/Windows/Start\ Menu/Programs/TagRename
wine shortcut /f:"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TagRename\TagRename.lnk" /a:c /t:"C:\Program Files\TagRename\TagRename.exe" /i:"C:\Program Files\TagRename\TagRename.exe,0"
sleep 3
[ -d $HOME/.local/share/applications/wine/Programs/TagRename ] || mkdir -p $HOME/.local/share/applications/wine/Programs/TagRename
cp $INSTALL_DIRECTORY/settings/wine/tag-rename/TagRename.desktop $HOME/.local/share/applications/wine/Programs/TagRename

ICON_FILENAME=$(find ~ -name "*TagRename*.png" -printf "%f" -quit)
ICON_FILENAME=${ICON_FILENAME%.*}

sed -i "s/Icon=/Icon=$ICON_FILENAME/" $HOME/.local/share/applications/wine/Programs/TagRename/TagRename.desktop
sed -i "s/\*\*\*/$CURRENT_USER/" $HOME/.local/share/applications/wine/Programs/TagRename/TagRename.desktop

echo
tput setaf 4
echo "################################################################"
echo "################### Wine : Youtube downloader ##################"
echo "################################################################"
tput sgr0
echo
file="$HOME/Downloads/YouTubeDownloader-x64.exe"
if [[ -f $file ]];then
    tput setaf 2
    echo $file " already exists"
    tput sgr0
else
    tput setaf 1
    echo $file " doesn't exist - Downloading now : "
    tput sgr0
    wget -O $HOME/Downloads/YouTubeDownloader-x64.exe https://www.mediahuman.com/fr/download/YouTubeDownloader-x64.exe
fi
wine $HOME/Downloads/YouTubeDownloader-x64.exe
sleep 3
rm -v ~/Desktop/MediaHuman\ YouTube\ Downloader.lnk
rm -v ~/Desktop/Visit\ MediaHuman\ Website.url
rm -v ~/Desktop/MediaHuman\ YouTube\ Downloader.desktop

[ -d $HOME.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader ] || mkdir -p $HOME/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader
cp $INSTALL_DIRECTORY/settings/wine/youtube-downloader/MediaHuman\ YouTube\ Downloader.desktop $HOME/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader
sed -i "s/\*\*\*/$CURRENT_USER/" $HOME/.local/share/applications/wine/Programs/MediaHuman/YouTube\ Downloader/MediaHuman\ YouTube\ Downloader.desktop       

echo
tput setaf 4
echo "################################################################"
echo "######################### Virtual box ##########################"
echo "################################################################"
tput sgr0
echo
echo "VirtualBox check - Install VirtualBox or not"

result=$(systemd-detect-virt)
if [ $result = "none" ];then

	echo
	tput setaf 2
	echo "################################################################"
	echo "######################### Installing ###########################"
	echo "################################################################"
	tput sgr0
	echo	

    echo "###########################################################################"
    echo "##         This script assumes you have the linux kernel running         ##"
    echo "###########################################################################"


    if pacman -Qi linux &> /dev/null; then

        tput setaf 2
        echo "################################################################"
        echo "##################  Installing linux-headers ###################"
        echo "################################################################"
        tput sgr0
        echo
        sudo pacman -S --needed linux-headers
    fi

    sudo pacman -S --noconfirm --needed virtualbox
    sudo pacman -S --noconfirm --needed virtualbox-host-dkms
    sudo pacman -S --noconfirm --needed virtualbox-guest-iso

    #echo "###########################################################################"
    #echo "##           Removing all the messages virtualbox produces               ##"
    #echo "###########################################################################"
    #VBoxManage setextradata global GUI/SuppressMessages "all"

else

	echo
	tput setaf 1
	echo "################################################################"
    echo "######                                                    ######"
	echo "###### You are on a virtual machine - skipping VirtualBox ######"
    echo "######                                                    ######"
	echo "######        /!\ VirtualBox is NOT installed /!\         ######"
    echo "######                                                    ######"
	echo "################################################################"
	tput sgr0
	echo

fi

echo
tput setaf 3
echo "################################################################"
echo "################## INSTALLATION COMPLETE ! #####################"
echo "################################################################"
tput sgr0
echo
