#!/bin/bash
sudo pacman -Scc
sudo rm -R /etc/pacman.d/gnupg/
sudo gpg --refresh-keys
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman-key --refresh-keys
