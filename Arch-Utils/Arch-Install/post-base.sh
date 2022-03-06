#!/usr/bin/env bash
#################################################################
###                 _        _                          _     ###
### _ __   ___  ___| |_     | |__   __ _ ___  ___   ___| |__  ###
###| '_ \ / _ \/ __| __|____| '_ \ / _` / __|/ _ \ / __| '_ \ ###
###| |_) | (_) \__ \ ||_____| |_) | (_| \__ \  __/_\__ \ | | |###
###| .__/ \___/|___/\__|    |_.__/ \__,_|___/\___(_)___/_| |_|###
###|_|                                                        ###
#################################################################

echo '#####################################################################################################################'
echo '###      _/_/                        _/                  _/_/_/                        _/                _/  _/   ###'
echo '###   _/    _/  _/  _/_/    _/_/_/  _/_/_/                _/    _/_/_/      _/_/_/  _/_/_/_/    _/_/_/  _/  _/    ###'
echo '###  _/_/_/_/  _/_/      _/        _/    _/  _/_/_/_/_/  _/    _/    _/  _/_/        _/      _/    _/  _/  _/     ###'
echo '### _/    _/  _/        _/        _/    _/              _/    _/    _/      _/_/    _/      _/    _/  _/  _/      ###'
echo '###_/    _/  _/          _/_/_/  _/    _/            _/_/_/  _/    _/  _/_/_/        _/_/    _/_/_/  _/  _/       ###'
echo '#####################################################################################################################'                                                                                                               


if  (( "$EUID" == 0 ))
then
    echo "PLEASE DO NOT RUN THE SCRIPT AS ROOT"
    exit
else
	sudo timedatectl --adjust-system-clock set-local-rtc true
    pushd "$HOME" || return
    ############################################################################################
    ### Variables
   # Drivers
    declare -A drivers
    drivers['intel']="xf86-video-intel"
    drivers['amd']="xf86-video-ati"
    drivers['nvidia']="xf86-video-noveau"
    # Packages
    packages=(
        xorg
        xorg-xinit
        nitrogen
        picom-jonaburg-git
        awesome
        kitty
        zsh
        neofetch
        vim
        base-devel
        bluez
        bluez-utils
        blueman
        alsa-utils
        unzip
        openssh
        sof-firmware
        dnsmasq
        pulseaudio
        pulseaudio-alsa
        pulseaudio-bluetooth
        fzf
        maim
        xclip
        tree
        exa
        bat
        fd
        zathura
        emacs
        dunst
        network-manager-applet 
        blueberry
        xfce4-power-manager
        mpv
        dolphin
        ranger
        sxiv
        zathura-pdf-mupdf
        neovim
        pamixer
        pandoc
        pavucontrol
        procs
        rofi
        starship
        fuse2
        fuse3
        ripgrep
        lightdm
        lightdm-webkit2-greeter
        wget emacs
        bandwhich
        acpi
        brave-bin
        figlet
        xcp
        tty-clock
        nerd-fonts-jetbrains-mono
        todoist-appimage
        notion-app
        #ytop
        lightdm-webkit-theme-aether
        zip
        atom
        pup
        python-pip
        tmux
        ntfs-3g
        unimatrix
        pyenv
        xdotool
        cmake 
        rhash
        jsoncpp
        dart
        nim
        btop
        #nimsuggest-git
        python-black
        python-pyflakes
        python-pipenv
        python-nose
        python-pytest
        shellcheck
        imagemagick
        #mbsync
        #mu
        dash
        qbittorrent
        virt-manager 
        qemu 
        vde2 
        ebtables 
        dnsmasq 
        bridge-utils 
        openbsd-netcat

    )
    pip_packages=(
	    neovim
	    jedi
	    autopep8
	    flake8
	    ipython
	    importmagic
	    yapf
	    black
	    pyflakes
	    isort
	    pipenv
	    nose
	    pytest
		debugpy
	    )
    ### FUNCTIONS
    install_driver () {

        printf  '%s' "$1 drivers: "
        read -r is_driver
        case $is_driver in
        "y" | "Y" | "")
            paru -S --noconfirm --needed ${drivers[$1]}
	    sleep 1
            clear
            ;;
        "n" | "N")
            echo "Not Installing $1 Drivers"
            ;;
        *)
            echo "please enter Y/n"
            install_driver "$1"
            ;;
        esac

    }
    mirror_msg () {
        clear
        echo "########################"
        echo "### UPDATING MIRRORS ###"
        echo "########################"
        echo ""
    }
   paru_msg () {
        clear
        echo "#######################"
        echo "### INSTALLING PARU ###"
        echo "#######################"
        echo ""
   }

    ############################################################################################
    echo "############################################################"
    echo "### BEFORE RUNNING THE SCRIPT ENABLE MULTILIB REPOSITORY ###"
    echo "### FOR FASTER SETUP ALSO ENABLE PARALLEL DOWNLOADS ########"
    echo "################# ( SET PARALLEL TO $(( $(nproc)+1 )) ) #####################"
    echo "############################################################"
    sleep 3
    clear
    printf "Update Mirrors (THIS MAY TAKE AN HOUR OR 2 ) : "
    read -r up_mirror
    echo "########################"
    echo "### SYNCING DATABASE ###"
    echo "########################"
    echo ""
    sudo pacman -Syy
    clear
    case $up_mirror in
	    'y' | 'Y' )
		    mirror_msg
		    sudo pacman -S --needed reflector rsync
		    mirror_msg
		    sudo reflector  --sort rate --threads $(( $( nproc ) + 1 ))  -l 300 --save /etc/pacman.d/mirrorlist
		    ;;
	    *)
		    echo "NOT UPDATING MIRRORS AND CONTINUING"
		    ;;
   esac
   paru_msg
   sudo pacman -S --needed --noconfirm base-devel
   clear
   paru_msg
   mkdir -pv "$HOME/Github"
   pushd Github 
   git clone https://aur.archlinux.org/paru.git
   clear
   paru_msg
   pushd paru
   makepkg -si
   popd
   clear

   echo "##########################"
   echo "### INSTALLING DRIVERS ###"
   echo "##########################"
   echo ""
   sudo paru -S --needed --noconfirm xf86-video-vesa mesa mesa-libgl
   clear
   for driver in "${!drivers[@]}"
   do
       install_driver $driver
   done
   echo "#################################"
   echo "### INSTALLING OTHER PACKAGES ###"
   echo "#################################"
   paru -S --needed --noconfirm "${packages[@]}"
   echo ""
   clear
   echo "###############################"
   echo "### INSTALLING PIP PACKAGES ###"
   echo "###############################"

   pip install "${pip_packages[@]}"
   clear
   echo "##################################"
   echo "### SETTING UP GRUB BOOTLOADER ###"
   echo "##################################"
   echo "DETECTING OTHER OS"
   sudo os-prober
   echo "updating grub ....."
   sudo grub-mkconfig -o /boot/grub/grub.cfg >> /dev/null
   sudo sed -i "s/^#GRUB_DISABLE_OS_PROBER/GRUB_DISABLE_OS_PROBER/g"
   sudo grub-mkconfig -o /boot/grub/grub.cfg 
   echo "ADDING GRUB BOOTLOADER THEME"
   pushd "$HOME/Github"
   git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes
   sudo Top-5-Bootloader-Themes/install.sh
   clear 
   echo "###############################"
   echo "### SETTING UP VIRT-MANAGER ###"
   echo "###############################"
   sudo systemctl start libvirtd
   sudo virsh net-start default
   sudo virsh net-autostart default
   sudo virsh net-list --all
   sudo usermod -aG libvirt "$USER"
   clear
   echo "#################################"
   echo "### SETTING UP OPENSSH-SERVER ###"
   echo "#################################"
   sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
   sed -i 's/^#X11Forwarding no/X11Forwarding no/' /etc/ssh/sshd_config
   echo "PermitRootLogin no" >> /etc/ssh/sshd_config
   clear
   echo "########################"
   echo "### SETTING UP XORG ####"
   echo "########################"
   touch .xinitrc
   echo "exec awesome" >> .xinitrc
   clear
   echo "#########################"
   echo "### ENABLING SERVICES ###"
   echo "#########################"
   sudo systemctl enable lightdm
   sudo systemctl enable bluetooth
   sudo systemctl enable libvertd
   clear
   echo "#############################"
   echo "### ARCH INSTALL COMPLETE ###"
   echo "#############################"
fi
popd
