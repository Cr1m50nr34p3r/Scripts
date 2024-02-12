#!/usr/bin/env bash
#############################################                                       
###      _                _         _     ###
###  ___| |__   ___  __ _| |_   ___| |__  ###
### / __| '_ \ / _ \/ _` | __| / __| '_ \ ###
###| (__| | | |  __/ (_| | |_ _\__ \ | | |###
### \___|_| |_|\___|\__,_|\__(_)___/_| |_|###
#############################################                                       

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
       kitty -e --hold curl  cht.sh/$selected/$query | less -r
	elif [[ "${utils[@]}" =~ "${selected}" ]]
	then
        kitty -e --hold  curl cht.sh/$selected~$query | less -r
	fi
	;;
"f" | "F")
	selected=$( echo "${languages[@]}" "${utils[@]}" | xargs -n 1 | fzf --prompt="Select Language/Util: " --preview="man {} || clear && curl -s cht.sh/{} " --bind="?:toggle-preview" )
	read -p "query: " query
	if [[ "${languages[@]}" =~ "${selected}" ]]
	then
		clear
		curl cht.sh/$selected/$query | less -r 
	elif [[ "${utils[@]}" =~ "${selected}" ]]
	then
		clear
		curl cht.sh/$selected~$query | less
	fi
	;;
*)
	;;
esac
