#!/usr/bin/env bash

source ~/.nixos/modules/home/hyprland/scripts/exec.sh

handle() {
    # echo $1
    case $1 in
    monitorremoved*)
        portID="${1#*>>}"

        # If removed monitor is external
        if [[ $portID == "DP-"* ]]; then
            hyprctl keyword workspace 3, gapsout:$(hyprctl getoption general:gaps_out -j | jq -r '.custom')
            enableMonitor eDP-1
        fi
        ;;

    monitoradded*)
        data="${1#*>>}"

        # Turn on monitor
        hyprctl dispatch dpms on

        if echo $1 | grep 'AW3423DWF'; then
            # Move all workspaces to monitor
            for workspace in $(hyprctl workspaces -j | jq -r '.[].id'); do
                hyprctl dispatch moveworkspacetomonitor "$workspace $(awk -F ',' '{print $1}' <<<"$data")"
            done
            hyprctl keyword workspace 3, gapsout:20 600 20 600
        fi
        ;;

    windowtitle*)
        window_id=''${1#*>>}
        window_info=$(hyprctl clients -j | jq --arg id "0x$window_id" '.[] | select(.address == ($id))')
        window_title=$(echo "$window_info" | jq '.title')

        # Fix firefox bitwarden extension window launching maximized
        if [[ "$window_title" == *"Extension: (Bitwarden Password Manager)"* && "$(echo "$window_info" | jq '.floating')" == "false" ]]; then
            hyprctl dispatch togglefloating address:0x$window_id
            hyprctl dispatch resizewindowpixel exact 20% 40%,address:0x$window_id
            # hyprctl dispatch movewindowpixel exact 40% 30%,address:0x$window_id
        fi
        ;;

    openwindow* | movewindow*)
        data="${1#*>>}"
        window_address=$(awk -F ',' '{print $1}' <<<"$data")
        workspace_name=$(awk -F ',' '{print $2}' <<<"$data")

        # # Obsidian workspace side gaps on <3 windows
        # If workspace is on external monitor and has < 3 windows and has small gaps
        portID=$(hyprctl workspaces -j | jq -r '.[] | select(.name == "obsidian") | .monitor')
        windowsCount=$(hyprctl workspaces -j | jq -r '.[] | select(.name == "obsidian") | .windows')
        if [[ $portID == "DP-"* && $windowsCount < 3 ]]; then
            hyprctl keyword workspace 3, gapsout:20 600 20 600
        else
            hyprctl keyword workspace 3, gapsout:$(hyprctl getoption general:gaps_out -j | jq -r '.custom')
        fi

        #         gapsOut=$(hyprctl workspacerules -j | jq -r ' .[] | select(.workspaceString == "3" and .monitor == "desc:Dell Inc. AW3423DWF 50H82S3") | .gapsOut')
        # windowsCount=$(hyprctl workspaces -j | jq -r '.[] | select(.name == "obsidian") | .windows')
        # if [[ $windowsCount -lt 3 && $gapsOut != null && $(echo "$gapsOut" | jq '.[1]') -lt 600 ]]; then
        #     hyprctl keyword workspace 3, gapsout:20 600 20 600
        # else
        #     hyprctl keyword workspace 3, gapsout:$(hyprctl getoption general:gaps_out -j | jq -r '.custom')
        # fi
        # fi
        ;;

    esac
}

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do handle "$line"; done
