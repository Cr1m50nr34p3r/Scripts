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
Select="Personal"
Write=1
CurDecade="$(date +%Y | sed 's/\(.*\)[0-9]$/\10s/g')"
FileName="$HOME/.dlogs/.$Select/$CurDecade/$(date +%Y)/$(date +%b)/$(date +%d-%m-%Y).md"
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
  gpg -c $1 && rm -v $1 || echo "unencrypted"
  gpgconf --kill gpg-agent 

}

dec() {
  en_file="$1.gpg"
  if [[ -f $en_file ]] then
    gpg -d $en_file > $1 || {
      echo "Couldnt decrypt" >&2
      exit 1
    }
    rm -v $en_file
    gpgconf --kill gpg-agent 
  fi
}

gitup() {
  pushd $HOME/.dlogs/
  git add .
  git commit -m "Added an Entry"
  git push origin
  popd
}
function help {
		echo "usage: 	$0 [-p|d|s]"
		echo "d: 		Dream log"
		echo "p: 		Personal log"
		echo "s: 		Schedule"
    echo "r:    Read"
	}

### Selection
while getopts ":shpr:h" opt 
do
  case "$opt" in
    s)
      Select="Schedule"
      ;;
    d) 
      Select="Dream"
      ;;
    p)
      Select="Personal"
      ;;
    r)
      Write=0
      if [[ "$OPTARG" == "r" ]]
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
      FileName="$HOME/.dlogs/.$Select/$Decade/$Year/$MonthWord/$date.md"

      exit

      

      ;;
    h|*) help  && exit 1 ;;
  esac
done
##### MAIN BLOCK
if [[ -e "$FileName.gpg" ]]
then
  dec $FileName
fi
if (( Write ))
then
  write $FileName
  gitup
else 
    cat $FileName | less
fi

enc $FileName
