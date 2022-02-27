#!/bin/sh

#######################################################################
###                           _                     _         _     ###
### _ __  _ __ ___        ___| |__  _ __ ___   ___ | |_   ___| |__  ###
###| '_ \| '__/ _ \_____ / __| '_ \| '__/ _ \ / _ \| __| / __| '_ \ ###
###| |_) | | |  __/_____| (__| | | | | | (_) | (_) | |_ _\__ \ | | |###
###| .__/|_|  \___|      \___|_| |_|_|  \___/ \___/ \__(_)___/_| |_|###
###|_|                                                              ###
#######################################################################
echo '#####################################################################################################################'
echo '###      _/_/                        _/                  _/_/_/                        _/                _/  _/   ###'
echo '###   _/    _/  _/  _/_/    _/_/_/  _/_/_/                _/    _/_/_/      _/_/_/  _/_/_/_/    _/_/_/  _/  _/    ###'
echo '###  _/_/_/_/  _/_/      _/        _/    _/  _/_/_/_/_/  _/    _/    _/  _/_/        _/      _/    _/  _/  _/     ###'
echo '### _/    _/  _/        _/        _/    _/              _/    _/    _/      _/_/    _/      _/    _/  _/  _/      ###'
echo '###_/    _/  _/          _/_/_/  _/    _/            _/_/_/  _/    _/  _/_/_/        _/_/    _/_/_/  _/  _/       ###'
echo '#####################################################################################################################'                                                                                                               
echo "### UPDATING SYSTEM CLOCK ###"
echo "#############################"
timedatectl set-ntp true
read -p "Update Mirrors: " UpMirror
part_msg () {
    clear
	echo "####################"
	echo "### PARTITIONING ###"
	echo "####################"
	echo ""
}
part_msg
lsblk
printf "Which Drive do u wanna partition: "
read disk
cfdisk /dev/$disk
clear &&  part_msg
echo "FORMATTING AND MOUNTING PARTITIONS"
lsblk
printf "What is your EFI  partition: "
read efi_part
printf "What is your root partition: "
read root_part
printf "Do you have separate home partition: "
read is_home
case $is_home in
    'y' | 'Y') printf "What is your home partition: " && read home_part;;
    'n' | 'N' | * ) echo ""
esac
printf "do you have a Swap: "
read is_swap
case $is_swap in
    'y' | 'Y' )
        printf "Name of Swap Partition: "
        read swap_part
        ;;
    'n' | 'N' | *) echo "" ;;
esac

mkfs.fat -F32 /dev/$efi_part
mkfs.ext4 /dev/$root_part
mount /dev/$root_part /mnt
case $is_swap in
    'y' | 'Y')
        mkswap /dev/$swap_part
        swapon /dev/$swap_part
        ;;
    'n' | 'N' | *)
        echo ""
        ;;
esac
case $is_home in
    'y' | 'Y' ) 
        mkdir -v /mnt/home
        mkfs.ext4 "/dev/$home_part"
        mount "/dev/$home_part" /mnt/home 
clear
case $UpMirror in
"y" | "Y")
    mirror_msg () {
        echo "########################"
        echo "### UPDATING MIRRORS ###"
        echo "########################"
        echo ""

    }
    mirror_msg
    pacman -Sy --needed reflector rsync
    clear
    mirror_msg
    reflector --sort rate --threads $(($(nproc)+1)) -l 300 --verbose --save /etc/pacman.d/mirrorlist
    ;;
'n' | 'N' | *)
    echo "Cantinuing to Installing Base System ...."
    ;;
esac
echo "##############################"
echo "### INSTALLING BASE SYSTEM ###"
echo "##############################"
pacstrap /mnt base linux linux-firmware linux-headers base-devel
genfstab -U /mnt >> /mnt/etc/fstab
clear
echo "COPYING SCRIPT FILES ..... "
cp -rv $HOME/Arch-Install /mnt
echo "CHANGING ROOT"
arch-chroot /mnt
