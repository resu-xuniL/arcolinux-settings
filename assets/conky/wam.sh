#!/usr/bin/env bash

weather_icon() {
    local icons_path=~/.config/conky/images/meteo-icons
    local icon_name=$(jq .current.weather_code ~/.cache/openmeteo/weather.json)

    if [[ $(date +"%H") > 07 && $(date +"%H") < 22 ]]; then
        cp -f ${icons_path}/${icon_name}.png ~/.cache/openmeteo/current.png
    elif [ ! -f ${icons_path}/${icon_name}n.png ]; then
        cp -f ${icons_path}/${icon_name}.png ~/.cache/openmeteo/current.png
    else
        cp -f ${icons_path}/${icon_name}n.png ~/.cache/openmeteo/current.png
    fi
}

weather_icon
