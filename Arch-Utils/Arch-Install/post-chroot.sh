#!/usr/bin/env bash
###########################################################################
###                 _             _                     _         _     ###
### _ __   ___  ___| |_       ___| |__  _ __ ___   ___ | |_   ___| |__  ###
###| '_ \ / _ \/ __| __|____ / __| '_ \| '__/ _ \ / _ \| __| / __| '_ \ ###
###| |_) | (_) \__ \ ||_____| (__| | | | | | (_) | (_) | |_ _\__ \ | | |###
###| .__/ \___/|___/\__|     \___|_| |_|_|  \___/ \___/ \__(_)___/_| |_|###
###|_|                                                                  ###
###########################################################################
echo '#####################################################################################################################'
echo '###      _/_/                        _/                  _/_/_/                        _/                _/  _/   ###'
echo '###   _/    _/  _/  _/_/    _/_/_/  _/_/_/                _/    _/_/_/      _/_/_/  _/_/_/_/    _/_/_/  _/  _/    ###'
echo '###  _/_/_/_/  _/_/      _/        _/    _/  _/_/_/_/_/  _/    _/    _/  _/_/        _/      _/    _/  _/  _/     ###'
echo '### _/    _/  _/        _/        _/    _/              _/    _/    _/      _/_/    _/      _/    _/  _/  _/      ###'
echo '###_/    _/  _/          _/_/_/  _/    _/            _/_/_/  _/    _/  _/_/_/        _/_/    _/_/_/  _/  _/       ###'
echo '#####################################################################################################################'
echo "#######################"
echo "### BASIC QUESTIONS ###"
echo "#######################"
lsblk
printf "Name of EFI Partition: "
read efi_part
printf "Hostname: "
read hostname
printf "Username: "
read username
clear
echo '#########################'
echo '### SETTING TIME ZONE ###'
echo '#########################'
echo ""
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
clear
echo '##########################'
echo "### GENERATING LOCALES ###"
echo '##########################'
echo ""
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
clear
echo '######################################'
echo "### STARTING NETWORK CONFIGURATION ###"
echo '######################################'
echo ""
echo "creating /etc/host..."
echo $hostname >> /etc/hostname
echo "creating /etc/hosts....."
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.0.1     $hostname.localdomain $hostname" >> /etc/hosts
echo "INITRAMFS"
echo ""
mkinitcpio -P
clear
echo '##############################'
echo "### CHANGING ROOT PASSWORD ###"
echo '##############################'
echo ""
passwd
clear
echo '#######################'
echo "### ADDING NEW USER ###"
echo '#######################'
echo ""
useradd -m $username
echo "create password for $username"
echo ""
clear
passwd $username
echo "adding user to groups....."
usermod -aG wheel,video,optical,storage,audio $username
echo "setting up sudo ...."
echo ""
pacman -S --needed --noconfirm sudo vi vim
clear
echo "setup sudo "
visudo
clear
grub_msg () {
	echo '#######################'
	echo "### SETTING UP GRUB ###"
	echo '#######################'
	echo ""
}
grub_msg
pacman -S --noconfirm os-prober grub efibootmgr dosfstools mtools
clear
grub_msg
echo "Creating EFI directory ...."
mkdir -v /boot/EFI
echo ""
echo "Mounting EFI partition"
mount /dev/$efi_part /boot/EFI
echo "Installing grub"
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg
clear
echo '##############################'
echo "### INSTALLING BASIC STUFF ###"
echo '##############################'
pacman -S --noconfirm --needed vim networkmanager git connman
systemctl enable NetworkManager
clear
echo "#########################################"
echo "### ARCH LINUX SUCCESSFULLY INSTALLED ###"
echo "#########################################"
