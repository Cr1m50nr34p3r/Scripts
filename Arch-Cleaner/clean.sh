#!/bin/sh
sudo pacman -Sc
sudo paccache -r
sudo pacman -Rns (pacman -Qtdq)
sudo rm -rf ~/.cache/*
