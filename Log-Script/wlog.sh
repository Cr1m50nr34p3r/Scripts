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
CurDecade="$(date +%Y | sed 's/\(.*\)[0-9]$/\10/g')s"
### Function
## Check if the required directory exists
function DirCheck {
	if [[ ! -e "$HOME/.dlogs/$1/$CurDecade/$(date +%Y)/$(date +%b)" || ! -d "$HOME/.dlogs/$1/$CurDecade/$(date +%Y)/$(date +%b)" ]]
	then
		mkdir -pv "$HOME/.dlogs/$1/$CurDecade/$(date +%Y)/$(date +%b)"
	fi
}

function help {
		echo "usage: 	$0 [-p|d|s]"
		echo "d: 		Dream log"
		echo "p: 		Personal log"
		echo "s: 		Schedule"
	}

### Selection
while getopts "sdph" opt 
do
	case "$opt" in
		s) Select="Schedule";;
		d) Select="Dream";;
		p) Select="Personal";;
		h | * ) help  && exit ;;
	esac
done

if (($# < 1 ))
then
	Select="Personal"
fi


### Main
DirCheck ".$Select"
$EDITOR "~/.dlogs/.Dream/$CurDecade/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md" || "vim ~/.dlogs/.Dream/$CurDecade/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md" ;;
