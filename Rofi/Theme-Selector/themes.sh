#!/usr/bin/bash

declare -A themes
themes=(["sakura_castle"]="$HOME/Wallpaper/Sakura_Castle.jpg" ["desert_at_sunset"]="$HOME/Wallpaper/Waiting_at_the_desert.jpg" ["gruvbox_dark"]="$HOME/Wallpaper/Crimson_moonlit_port.jpg" ["ghibli_greenland"]="$HOME/Wallpaper/Ghibli Greenland.jpg")
theme=$(echo "${!themes[@]}"  | tr ' ' '\n' | rofi -dmenu -show-icons)
if [[ -v $theme ]]; then
  wallpaper=${themes[$theme]}
  wal --backend colorthief -i "$wallpaper"
  awww img "$wallpaper"
  sed -i "s/palette = \".*\"/palette = \"$theme\"/" $HOME/.config/starship.toml
fi
