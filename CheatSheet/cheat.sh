#!/usr/bin/env bash
set -euo pipefail

languages=(
    'python'
    'bash'
    'js'
    'git'
    'awk'
)
utils=(
    'xargs'
    'find'
    'sed'
    'grep'
    'tr'
    'cut'
    'curl'
    'dd'
    'pandoc'
    'imagemagick'
)

case $1 in
"r" | "R")
	

	selected=$( echo "${languages[@]}" "${utils[@]}" | xargs -n 1 | rofi -dmenu -P "Select Language/Util: ")
	query=$(rofi -dmenu -p "Enter Query" -l 0 | tr ' ' '+')
	if [[ "${languages[@]}" =~ "${selected}" ]]
	then
        kitty -e --hold  curl cht.sh/$selected/$query
	elif [[ "${utils[@]}" =~ "${selected}" ]]
	then
        kitty -e --hold curl cht.sh/$selected~$query
	fi
	;;
"f" | "F")
	selected=$( echo "${languages[@]}" "${utils[@]}" | xargs -n 1 | fzf --prompt="Select Language/Util: " --preview="man {} || clear && curl -s cht.sh/{} " --bind="?:toggle-preview" )
	read -p "query: " query
	if [[ "${languages[@]}" =~ "${selected}" ]]
	then
		clear
		tmux neww "curl cht.sh/$selected/$query | less"  
	elif [[ "${utils[@]}" =~ "${selected}" ]]
	then
		clear
		tmux neww curl cht.sh/$selected~$query | less
	fi
	;;
*)
	;;
esac
