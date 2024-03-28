#!/bin/bash

sudo sed -i 's/\${ZDOTDIR:-\$HOME}/\${ZDOTDIR:-\$HOME\/.config\/zsh}/' /usr/share/oh-my-zsh/oh-my-zsh.sh
echo 'ZDOTDIR : Path modified'
