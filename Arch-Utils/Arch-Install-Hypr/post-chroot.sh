#!/usr/bin/env bash
## ENV Variable

installed_packages = (
  acpi
  alsa-firmware
  alsa-utils
  awww
  base
  base-devel
  bat
  blueman
  bridge-utils
  brightnessctl
  btop
  btrfs-progs
  caffeine
  cronie
  dmidecode
  dms
  dnsmasq
  edk2-ovmf
  efibootmgr
  eza
  figlet
  fzf
  git
  gnome-themes-extra
  grub
  gstreamer-docs
  hyprland
  hyprpaper
  hyprpolkitagent
  hyprshot
  imv
  kitty
  linux
  linux-firmware
  linux-headers
  luarocks
  macchina
  man-db
  mpv
  neovim
  networkmanager
  nomacs
  npm
  ntfs-3g
  nwg-look
  paru
  paru-debug
  pavucontrol
  pipewire-alsa
  pipewire-audio
  pipewire-jack
  pipewire-pulse
  playerctl
  pup
  python-colorthief
  python-flake8
  python-haishoku
  python-pip
  python-pipx
  python-pywal16
  qbittorrent
  qemu-base
  qt5-wayland
  qt6ct
  quickshell
  rofi
  sddm
  snapd
  sof-firmware
  starship
  stow
  sudo
  swaybg
  swayidle
  swaylock
  swaync
  swtpm
  sxiv
  tmux
  ttf-dejavu
  ttf-iosevka-nerd
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  ttf-roboto
  ttf-ubuntu-font-family
  tty-clock
  vde2
  vim
  virt-manager
  virt-viewer
  wallust-git
  waybar-cava-git
  waypaper
  wl-clipboard
  woff2-font-awesome
  xclip
  xdg-desktop-portal-gnome
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-wlr
  zathura
  zen-browser-bin
  zig
  zoxide
  zram-generator
  zsh
)



timedatectl set-timezone Asia/Kolkata
hwclock --systohc
sed -i "s/\#\(en_US\.UTF-8 UTF-8\)/\1/g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
printf "Hostname: "
read -r hostname
echo "$hostname" > /etc/hostname
printf "Username: "
read -r username
useradd -m $username
usermod -aG wheel,audio,disk,input,optical,storage,video,users $username
echo "Add wheel group to sudo"
echo " Uncomment line"
echo '# %wheel ALL=(ALL:ALL) ALL'
echo ""
sleep 5
visudo
pacman -S zram-generator
echo '[zram0]' > /etc/systemd/zram-generator.conf
echo 'zram-size = ram / 2' >> /etc/systemd/zram-generator.conf
echo 'compression-algorithm = zstd' >> /etc/systemd/zram-generator.conf
echo 'mount-point = /dev/zram0' >> /etc/systemd/zram-generator.conf
pacman -S grub efibootmgr
clear
lsblk
echo ""
printf "EFI-Partition: "
read -r efi_part
mount /dev/$efi_part /boot/ 
grub-install --target=x86_64-efi --efi-directory = /boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S networkmanager
clear
printf "username: "
read -r username
su  $username
echo "DONE"




