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
Select=""
CurDecade="$(date +%Y | sed 's/\(.*\)[0-9]$/\10s/g')"
### Function
function help {
		echo "usage: 	$0 [-p|d|s]"
		echo "d: 		Dream log"
		echo "p: 		Personal log"
		echo "s: 		Schedule"
	}

### Selection
if (($# < 1 ))
then
	Select="Personal"
else
	while getopts "sdph" opt 
	do
		case "$opt" in
			s) Select="Schedule";;
			d) Select="Dream";;
			p) Select="Personal";;
			h | * ) help  && exit 1 ;;
		esac
	done
fi

### Main
if [[ ! -e "$HOME/.dlogs/.$Select/$CurDecade/$(date +%Y)/$(date +%b)" || ! -d "$HOME/.dlogs/.$Select/$CurDecade/$(date +%Y)/$(date +%b)" ]]
then
	mkdir -pv "$HOME/.dlogs/.$Select/$CurDecade/$(date +%Y)/$(date +%b)"
fi
$EDITOR "~/.dlogs/.$Select/$CurDecade/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md" || vim "~/.dlogs/.$Select/$CurDecade/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md" ;;
