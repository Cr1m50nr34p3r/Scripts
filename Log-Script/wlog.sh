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
Space="Personal"
Write=1
CurDecade="$(date +%Y | sed 's/\(.*\)[0-9]$/\10s/g')"
FileName="$HOME/.dlogs/.$Space/$CurDecade/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md"
### Function
write() {
  Dir=$(echo "$1" | sed 's/^\(.*\)\/[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]\.md/\1/g')
  if [[ ! -e "$Dir" || ! -d "$Dir" ]]
  then
    mkdir -pv "$Dir"
  fi
  $EDITOR "$1" || vim "$1" 

}
enc() {
  gpg --quiet -c $1 && rm $1 || echo "unencrypted"
  gpgconf --kill gpg-agent 

}

dec() {
  en_file="$1.gpg"
  if [[ -f $en_file ]] 
  then
    gpg --quiet -d $en_file || {
      echo "Couldnt decrypt" >&2
      exit 1
    }
  else
    echo "File Not Found trying to find unencrypted file" >&2
    return 1
  fi
  gpgconf --kill gpg-agent
}

function help {
		echo "usage: 	$0 [-p|d|s]"
		echo "d: 		Dream log"
		echo "p: 		Personal log"
		echo "s: 		Schedule"
    echo "r:    Read {date:- t=today}"
	}

### Space
while getopts ":shpr:h" opt 
do
  case "$opt" in
    s)
      Space="Schedule"
      ;;
    d) 
      Space="Dream"
      ;;
    p)
      Space="Personal"
      ;;
    r)
      Write=0
      if [[ "$OPTARG" == "t" ]]
      then 
        date="$(date +%d-%m-%Y)"
      else 
        date="$OPTARG"
      fi
      declare -A months=(
        [01]="Jan"
        [02]="Feb"
        [03]="Mar"
        [04]="Apr"
        [05]="May"
        [06]="Jun"
        [07]="Jul"
        [08]="Aug"
        [09]="Sep"
        [10]="Oct"
        [11]="Nov"
        [12]="Dec"
      )
      Year=$(echo $date | sed "s/\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9][0-9][0-9]\)/\3/g")
      Month=$(echo $date | sed "s/\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9][0-9][0-9]\)/\2/g")
      Date=$(echo $date | sed "s/\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9][0-9][0-9]\)/\1/g")
      Decade="$(echo $Year | sed 's/\(.*\)[0-9]$/\10s/g')"
      MonthWord="${months[$Month]}"
      FileName="$HOME/.dlogs/.$Space/$Decade/$Year/$MonthWord/$date.md"

      

      ;;
    h|*) help  && exit 1 ;;
  esac
done
##### MAIN BLOCK
pushd $HOME/.dlogs/ > /dev/null
git pull -q --rebase || {
    echo "Git pull failed" >&2
    popd > /dev/null
    exit 1
}
if (( Write ))
  then
    if logs=$(dec $FileName)
    then
      printf "%s\n" "$logs" > $FileName
      rm "$FileName.gpg"
    fi
    write $FileName || {
      echo "FILE NOT FOUND"
      exit 1
    }
    enc $FileName
    git add . > /dev/null
    git commit -m "Added an Entry" > /dev/null
    git push -q origin 
else 
  (dec $FileName || cat $FileName) | (PAGER="less -~ -R +1" glow -p - || less -~ -R +1) 
fi
popd > /dev/null

