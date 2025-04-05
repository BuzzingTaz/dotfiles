#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly

notif="$HOME/.config/swaync/images/bell.png"

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	hyprctl keyword general:layout dwindle
	hyprctl keyword unbind SUPER,J
	hyprctl keyword unbind SUPER,K
	hyprctl keyword bind SUPER,J,movefocus, d
	hyprctl keyword bind SUPER,K,movefocus, u
	hyprctl keyword bind SUPER SHIFT,O,togglesplit
  notify-send -e -u low -i "$notif" "Dwindle Layout"
	;;
"dwindle")
	hyprctl keyword general:layout master
	hyprctl keyword unbind SUPER,J
	hyprctl keyword unbind SUPER,K
	hyprctl keyword unbind SUPER SHIFT,O
	hyprctl keyword bind SUPER,J,layoutmsg,rollnext
	hyprctl keyword bind SUPER,K,layoutmsg,rollprev
  notify-send -e -u low -i "$notif" "Master Layout"
	;;
*) ;;

esac
