#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Screenshots scripts

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts"
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"

time=$(date "+%d-%b_%H-%M-%S")
dir="$(xdg-user-dir)/Pictures/Screenshots"
file="Screenshot_${time}_${RANDOM}.png"

active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
active_window_file="Screenshot_${time}_${active_window_class}.png"
active_window_path="${dir}/${active_window_file}"

monitorID=$(hyprctl activeworkspace | grep 'monitorID:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
monitorfile="Screenshot_${time}_M${monitorID}.png"

tmpfile={mktemp}
# notify and view screenshot
notify_view() {
    if [[ "$1" == "active" ]]; then
        if [[ -e "${active_window_path}" ]]; then
            ${notify_cmd_shot} "Screenshot of '${active_window_class}' Saved."
            # "${sDIR}/Sounds.sh" --screenshot
        else
            ${notify_cmd_shot} "Screenshot of '${active_window_class}' not Saved"
            "${sDIR}/Sounds.sh" --error
        fi
    elif [[ "$1" == "screen" ]]; then
        if [[ -e "${monitorfile}" ]]; then
            ${notify_cmd_shot} "Screenshot of monitor '${monitorID}' Saved."
            # "${sDIR}/Sounds.sh" --screenshot
        else
            ${notify_cmd_shot} "Screenshot of monitor '${monitorID}' not Saved"
            "${sDIR}/Sounds.sh" --error
        fi
    elif [[ "$1" == "swappy" ]]; then
		${notify_cmd_shot} "Screenshot Captured."
    else
        local check_file="$dir/$file"
        if [[ -e "$check_file" ]]; then
            ${notify_cmd_shot} "Screenshot Saved."
            # "${sDIR}/Sounds.sh" --screenshot
        else
            ${notify_cmd_shot} "Screenshot NOT Saved."
            "${sDIR}/Sounds.sh" --error
        fi
    fi
}


shotswappy() {
	geometry=$(slurp)
	grim -g $geometry - "$tmpfile" && notify_view "swappy"
	swappy -f - <"$tmpfile"
}

# take shots
shotnow() {
	grim - >"$tmpfile"

	if [[ -s "$tmpfile" ]]; then
		wl-copy <"$tmpfile"
		mv "$tmpfile" "$dir/$file"
		# TODO: Click for swappy
		notify_view
	else
		notify_view "failed"
	fi
}


shotarea() {
	geometry=$(slurp)
	grim -g "$geometry" - >"$tmpfile"

	if [[ -s "$tmpfile" ]]; then
		wl-copy <"$tmpfile"
		mv "$tmpfile" "$dir/$file"
		# Click for swappy
		notify_view
	else
		notify_view "failed"
	fi
}

shotactive() {
	active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
	active_window_file="Screenshot_${time}_${active_window_class}.png"
	active_window_path="${dir}/${active_window_file}"

	geometry=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
	grim -g "$geometry" - >"$tmpfile"
	if [[ -s "$tmpfile" ]]; then
		wl-copy <"$tmpfile"
		mv "$tmpfile" "$active_window_path"
		# Click for swappy
		notify_view "active"
	else
		notify_view "failed"
	fi
}

shotscreen() {
	monitorId=$(hyprctl -j activeworkspace | jq -r '"\(.monitor)"')
	monitorfile="Screenshot_${time}_M${monitorID}.png"

	geometry=$(hyprctl -j monitors | jq -r --arg id $monitorID '.[] | select(.id==($id|tonumber)) | "\(.x),\(.y) \(.width)x\(.height)"')
	grim -g "${geometry}" - >"$tmpfile"
	if [[ -s "$tmpfile" ]]; then
		wl-copy <"$tmpfile"
		mv "$tmpfile" "$monitorfile"
		# Click for swappy
		notify_view "screen"
	else
		notify_view "failed"
	fi

}



if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

if [[ "$1" == "--now" ]]; then
	shotnow
elif [[ "$1" == "--area" ]]; then
	shotarea
elif [[ "$1" == "--active" ]]; then
	shotactive
elif [[ "$1" == "--screen" ]]; then
	shotscreen
elif [[ "$1" == "--swappy" ]]; then
	shotswappy
else
	echo -e "Available Options : --now --area --active -screen --swappy"
fi

exit 0
