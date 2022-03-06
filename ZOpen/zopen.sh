#!/usr/bin/env bash
case $1 in
    'r' | 'R')
        file1=$(find $HOME -iname '*.pdf' | rofi -dmenu -p "Select file: " )
	if [[ -e "$file1" ]]
	then
		zathura --fork "$file1"
	fi
	;;
    'f' | 'F' | '' )

	file1=$( find $HOME -iname *.pdf | fzf --prompt="Select file: " --preview="cat {}" --bind='?:toggle-preview' --tac )
	zathura --fork $file1 
        ;;
esac
