#!/usr/bin/env bash

weather_icons() {
    local icons_path=~/.config/conky/images/meteo-icons
    local icon_name=$(jq .current.weather_code ~/.cache/openmeteo/weather.json)
    local temperature=$(LC_NUMERIC="en_US.UTF-8"; printf '%.*f' 0 $(jq .current.temperature_2m ~/.cache/openmeteo/weather.json))

    if [[ $(date +"%H") -gt 07 && $(date +"%H") -lt 22 ]]; then
        cp -f ${icons_path}/${icon_name}.png ~/.cache/openmeteo/current.png
    elif [ ! -f ${icons_path}/${icon_name}n.png ]; then
        cp -f ${icons_path}/${icon_name}.png ~/.cache/openmeteo/current.png
    else
        cp -f ${icons_path}/${icon_name}n.png ~/.cache/openmeteo/current.png
    fi

    if [[ ${temperature} -ge 17 ]]; then
        cp -f ${icons_path}/900.png ~/.cache/openmeteo/therm.png
    else
        cp -f ${icons_path}/901.png ~/.cache/openmeteo/therm.png
    fi
}

weather_icons
