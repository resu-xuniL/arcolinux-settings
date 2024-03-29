#!/usr/bin/env bash

switch_conky() {

    state=$(grep 'default_color' ${HOME}/.config/conky/WAM.conkyrc | cut -d "'" -f 2)
    
    if [[ ${state} == "black" ]]; then
        sed -i "s/draw_shades = true/draw_shades = false/" ${HOME}/.config/conky/WAM.conkyrc
        sed -i "s/default_shade_color = '#ffffff'/default_shade_color = '#000000'/" ${HOME}/.config/conky/WAM.conkyrc
        sed -i "s/default_color = 'black'/default_color = 'white'/" ${HOME}/.config/conky/WAM.conkyrc
    else
        sed -i "s/draw_shades = false/draw_shades = true/" ${HOME}/.config/conky/WAM.conkyrc
        sed -i "s/default_shade_color = '#000000'/default_shade_color = '#ffffff'/" ${HOME}/.config/conky/WAM.conkyrc
        sed -i "s/default_color = 'white'/default_color = 'black'/" ${HOME}/.config/conky/WAM.conkyrc
    fi
}

switch_conky