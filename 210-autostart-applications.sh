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
echo "################# Autostart some applications ##################"
echo "################################################################"
tput sgr0
echo

[ -d $HOME/.config/autostart ] || mkdir -p $HOME/.config/autostart
cp $INSTALL_DIRECTORY/settings/_extra/.login.sound.mp3 $HOME/
cp "$INSTALL_DIRECTORY/settings/autostart/"* $HOME/.config/autostart

sed -i "s/\*\*\*/$CURRENT_USER/" $HOME/.config/autostart/login.sound.desktop

tput setaf 3
echo "################################################################"
echo "##################### AUTOSTART COMPLETE ! #####################"
echo "################################################################"
tput sgr0
echo