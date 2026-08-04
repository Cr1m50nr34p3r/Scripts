#!/usr/bin/env bash
#################################################################################
###    _             _          ___           _        _ _       _   _       
###   / \   _ __ ___| |__      |_ _|_ __  ___| |_ __ _| | |     | | | |_   _  ###
###  / _ \ | '__/ __| '_ \ _____| || '_ \/ __| __/ _` | | |_____| |_| | | | | ###
### / ___ \| | | (__| | | |_____| || | | \__ \ || (_| | | |_____|  _  | |_| | ###
###/_/   \_\_|  \___|_| |_|    |___|_| |_|___/\__\__,_|_|_|     |_| |_|\__, | ###
###                                                                    |___/  ###
#################################################################################


# time
timedatectl set-ntp true
clear
echo "####################"
echo "### PARTITIONING ###"
echo "####################"
echo ""
echo "Create 2 partitions:"
echo "\n512MB\tEFI System\tBoot "
echo "\n - \tLinux File System\tRoot "
echo ""
printf "Choose disk for partitioning: "
read -r disk
cfdisk $disk
clear
echo "########################"
echo "### FORMATTING DISKS ###"
echo "########################"
echo ""
lsblk
printf "What is your EFI  partition: "
read efi_part
printf "What is your root partition: "
read root_part
mkfs.fat -F32 /dev/$efi_part
mkfs.btrfs -L Arch-Root /dev/$root_part
mount /dev/$root_part /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var_log
umount /mnt
mount -o noatime,compress=zstd,subvol=@ /dev/$root_part /mnt
mkdir -pv /mnt/{home,boot,.snapshots,var/log}
mount -o noatime,compress=zstd,subvol=@home /dev/$root_part /mnt/home
mount -o noatime,compress=zstd,subvol=@snapshots /dev/$root_part /mnt/.snapshots
mount -o noatime,compress=zstd,subvol=@var_log /dev/$root_part /mnt/var/log
mount /dev/$efi_part /mnt/boot
pacstrap /mnt base linux-firmware linux-headers base-devel sudo vim
genfstab -U /mnt >> /mnt/etc/fstab
clear
echo "Copying Install Files"
cp -rv $(pwd) /mnt
echo "RUN: arch-chroot"





