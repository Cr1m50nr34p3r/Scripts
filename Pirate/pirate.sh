#!/bin/bash
query=$( rofi -dmenu -l 0 -p "Search Torrent: "| tr ' ' '+' )
base_url="https://1337x.wtf"
declare -a torrent_links
declare -a torrent_names
declare -a cache_files
declare -A torrent_urls
notify-send "getting list of available torrents"
curl -s "$base_url/search/$query/1/" -o "$HOME/.cache/1337x.wtf"
cache_files+=("1337x.wtf")
torrent_links_tmp=$(grep -Eo '"\/torrent\/[0-9]{7}\/.*/"' "$HOME/.cache/1337x.wtf" | sed 's/"\(.*\)"/\1/g') 
for link in $torrent_links_tmp
do
    torrent_links+=("$link")
    torrent_names+=("$(echo "$link" | cut -d '/' -f4)")
     
done
for ((i=0 ; i < ${#torrent_names[@]} ; i++))
do
    torrent_urls["${torrent_names[$i]}"]="${torrent_links[$i]}"
done
selection=$(echo "${torrent_names[@]}" | tr ' ' '\n' | rofi -dmenu -i -l 10 -p "Select Torrent")
notify-send "getting magnet link ...."
curl -s "$base_url${torrent_urls[$selection]}" -o "$HOME/.cache/1337x.wtf"
magnet_link=$(grep -Eo '"magnet:\?xt=urn:btih:[0-9a-fA-F]{40,}.*" ' "$HOME/.cache/1337x.wtf"  | sed 's/"\(.*\)"/\1/')
notify-send "got magnet link"
tool_opt=$(echo "stream download" | tr ' ' '\n' | rofi -dmenu -l 2 )
case $tool_opt in
    download ) qbittorrent "$magnet_link" ;;
    stream ) webtorrent "$magnet_link" ;; 
esac 


