#!/usr/bin/env bash
echo "#######################"
echo "### INSTALLING PARU ###"
echo "#######################"

mkdir -pv ~/Github
pushd ~/Github
git clone https://aur.archlinux.org/paru.git
pushd paru
makepkg -si 
popd 
popd
clear
echo "###########################"
echo "### INSTALLING PACKAGES ###"
echo "###########################"
paru -S --needed "${installed_packages[@]}"
clear
echo "###################################"
echo "### STARTING ESSENTIAL SERVICES ###"
echo "###################################"

sudo systemctl start /dev/zram0
sudo systemctl enable --now NetworkManager

clear
echo "#######################"
echo "### SETTING UP lydm ###"
echo "#######################"

git clone https://codeberg.org/fairyglade/ly.git
cd ly
zig build
zig build installexe -Dinit_system=systemd
sudo systemctl enable ly@tty2.service
sudo curl https://codeberg.org/fairyglade/ly-community/raw/branch/main/animations/dur/blackhole-smooth-240x67.dur --output /etc/ly/blackhole-smooth-240x67.dur
sudo sed -i "s/\(dur_file_path =\).*/\1 \/etc\/ly\/blackhole-smooth-240x67.dur/" /etc/ly/config.ini

