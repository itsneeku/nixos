#!/usr/bin/env bash

searchSource() {
    local searchString="$1"
    local sourceFile=~/.nixos/modules/programs/hyprland/source/vars.conf
    grep -m 1 "$searchString" $sourceFile
}

onLidClose() {
    if getMonitorProps AW3423DWF; then
        disableMonitor eDP-1
        gapsOut=$(hyprctl getoption general:gaps_out -j | jq -r '.custom')
        gapsTop=$(echo $gapsOut | awk '{print $1}')
        gapsBottom=$(echo $gapsOut | awk '{print $3}')
        hyprctl keyword workspace 3, gapsout:$gapsTop 500 $gapsBottom 500
    else
        pidof hyprlock || hyprlock
    fi
}

onLidOpen() {
    enableMonitor eDP-1
}

enableMonitor() {
    local monitor="$1" # port ID || description || desc:description
    local monitorProps=$(getMonitorProps "$monitor" "name description disabled")
    local monitorPort=$(jq -r '.name' <<<"$monitorProps")
    local monitorDesc=$(jq -r '.description' <<<"$monitorProps")

    if ! $(jq -r '.disabled' <<<"$monitorProps"); then
        echo "Monitor $monitorDesc ($monitorPort) is already enabled"
        return 1
    fi

    # Get monitor config
    local sourceConfigKey=$(searchSource "$monitorDesc" | sed 's/Desc/Config/' | awk -F ' = ' '{print $1}')
    local sourceConfig=$(searchSource "$sourceConfigKey" | awk -F ' = ' '{print $2}')

    hyprctl keyword monitor "$monitorPort, $sourceConfig"
}

disableMonitor() {
    local monitor="$1" # $portID || $description || desc:$description
    local monitorProps=$(getMonitorProps "$monitor" "name description disabled")
    local monitorPort=$(jq -r '.name' <<<"$monitorProps")
    local monitorDesc=$(jq -r '.description' <<<"$monitorProps")

    if $(jq -r '.disabled' <<<"$monitorProps"); then
        echo "Monitor $monitorDesc ($monitorPort) is already disabled"
        return 1
    fi

    hyprctl keyword monitor $monitorPort, disable
}

isPortID() {
    if [[ $1 == *"DP-"* ]] || [[ $1 == *"HDMI-"* ]]; then
        return 0
    else
        return 1
    fi
}

getMonitorProps() {
    local monitor="$1"    # port ID || description || desc:description
    local properties=($2) # name description disabled
    local json_data=$(hyprctl monitors all -j)

    if isPortID "$monitor"; then
        local monitor_data=$(echo "$json_data" | jq -r ".[] | select(.name | contains(\"$monitor\"))")
    else
        if [[ $monitor == "desc:"* ]]; then
            local monitor=$(echo $monitor | sed 's/desc://')
        fi

        local monitor_data=$(echo "$json_data" | jq -r ".[] | select(.description | contains(\"$monitor\"))")
    fi

    # monitor not found
    if [ -z "$monitor_data" ]; then
        echo "No monitor found with description: $monitor"
        return 1
    fi

    # no properties requested
    if [ -z "$properties" ]; then
        echo "$monitor_data"
        return 0
    fi

    # construct json with the requested properties
    local json_result="{"
    for prop in "${properties[@]}"; do
        local value=$(echo "$monitor_data" | jq -r ".$prop")
        json_result+="\"$prop\":\"$value\","
    done

    # remove trailing comma and close json
    json_result="${json_result%,}}"

    echo "$json_result"
}
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    "$@"
fi
