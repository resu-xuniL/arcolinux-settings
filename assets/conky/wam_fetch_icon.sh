#!/usr/bin/env bash

weather_icons() {
    local icons_path=~/.config/conky/images/meteo-icons
    local icon_name=$(jq .current.weather_code ~/.cache/openmeteo/weather.json)
    local temperature=$(LC_NUMERIC="en_US.UTF-8"; printf '%.0f' $(jq .current.temperature_2m ~/.cache/openmeteo/weather.json))
    local current_hour=$((10#$(date +%H)))

    if [[ ${current_hour} -gt 7 && ${current_hour} -lt 22 ]]; then
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
