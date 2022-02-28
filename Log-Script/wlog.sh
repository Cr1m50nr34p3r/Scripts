#!/bin/bash
##########################################
###          _                   _     ###
###__      _| | ___   __ _   ___| |__  ###
###\ \ /\ / / |/ _ \ / _` | / __| '_ \ ###
### \ V  V /| | (_) | (_| |_\__ \ | | |###
###  \_/\_/ |_|\___/ \__, (_)___/_| |_|###
###                  |___/             ###
##########################################
### Variables
LogOpts=(
	"Personal"
	"Dream"
	"Schedule"
	)
Months=(
	"Jan"
	"Feb"
	"Mar"
	"Apr"
	"May"
	"Jun"
	"Jul"
	"Aug"
	"Sep"
	"Oct"
	"Nov"
	"Dec"
	)

### Function
## Check if the required directory exists
function DirCheck {
	
		for month in ${Months[@]}
		do
			if [[ ! -e "$HOME/.dlogs/$1/$(date +%Y)/$month" || ! -d "$HOME/.dlogs/$1/$(date +%Y)/$month" ]]
			then
				mkdir -pv "$HOME/.dlogs/$1/$(date +%Y)/$month"
			fi
		done
			

		
}

### Main
Select=$(echo "${LogOpts[@]}" | tr ' ' '\n' | fzf --prompt "Choose type of log")
case "$Select" in
	"Personal" | *) DirCheck ".$Select" && nvim ~/.dlogs/.Personal/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md ;;
	"Dream") DirCheck ".$Select" && nvim ~/.dlogs/.Dream/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md ;;
	"Schedule") DirCheck ".$Select" && nvim ~/.dlogs/.Schedule/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md ;;
esac	
