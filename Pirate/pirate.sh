#!/bin/bash
#############################################
###       _           _             _     ###
### _ __ (_)_ __ __ _| |_ ___   ___| |__  ###
###| '_ \| | '__/ _` | __/ _ \ / __| '_ \ ###
###| |_) | | | | (_| | ||  __/_\__ \ | | |###
###| .__/|_|_|  \__,_|\__\___(_)___/_| |_|###
###|_|                                    ###
#############################################

### Variables
base_url="https://1337x.wtf"
query=$( rofi -dmenu -l 0 -p "Search Torrent: "| tr ' ' '+' )
declare -A torrent_urls

### Main
notify-send "getting list of available torrents"
curl -s "$base_url/search/$query/1/" -o "$HOME/.cache/1337x.wtf"
for link in $(grep -Eo '"\/torrent\/[0-9]{7}\/.*/"' "$HOME/.cache/1337x.wtf" | sed 's/"\(.*\)"/\1/g')
do
    torrent_urls["$( echo "$link" | cut -d '/' -f4 )"]="$link" 
done
selection=$(echo "${!torrent_urls[@]}" | tr ' ' '\n' | rofi -dmenu -i -p "Select Torrent: ")
notify-send "getting magnet link ...."
echo "${torrent_urls[@]}"
curl -s "$base_url${torrent_urls[$selection]}" -o "$HOME/.cache/1337x.wtf"
magnet_link=$(grep -Eo '"magnet:\?xt=urn:btih:[0-9a-fA-F]{40,}.*" ' "$HOME/.cache/1337x.wtf"  | sed 's/"\(.*\)"/\1/')
notify-send "got magnet link"
tool_opt=$(echo "STREAM DOWNLOAD COPY" | tr ' ' '\n' | rofi -dmenu -i )
case $tool_opt in
    DOWNLOAD ) qbittorrent "$magnet_link" && notify-send "Downloading torrent for $selection" ;;
    STREAM ) peerflix -k "$magnet_link"  && notify-send "Streaming torrent for $selection" ;; 
    COPY | * ) echo "$magnet_link" | xclip -select clipboard  && notify-send "Magnet link for $selection has been copied to clipboard"
esac 

### CLeaning up
rm -fv "$HOME/.cache/1337x.wtf"
notify-send "Enjoy Watching !!!"
