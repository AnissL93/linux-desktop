#!/bin/bash

CONFIG_DIR=$HOME/.config
DESKTOP_DIR=$(pwd)

function term() {
	# Install terminal
	sudo apt intall curl
	
	echo "Install Oh my bash"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
	
	echo "Configure git"
	git config --global user.email "hy.lan@nus.edu.sg"
	git config --global user.user "Huiying Lan"
	
	echo "Install fzf"
	
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/System/fzf
	~/System/fzf/install
}


function dep() {
	sudo apt-get install xcb libxcb-xkb-dev x11-xkb-utils libxkbcommon-x11-dev libx11-dev libxinerama-dev libxft-dev libx11-xcb-dev libxcb-res0-dev libharfbuzz-dev xutils-dev libtool notification-daemon 

}

function input_method() {
	sudo apt install fcitx fcitx-rime
}

function install_desktop_apps() {
	cd $DESKTOP_DIR/st/
	sudo make install

	cd $DESKTOP_DIR/dmenu
	sudo make install

	cd $DESKTOP_DIR/dwm
	./install.sh

	ln -s $DESKTOP_DIR/Dotfiles/scripts/ $CONFIG_DIR/Scripts
	echo 'PATH=$PATH:$CONFIG_DIR/Scripts' >> ~/.bashrc

	# install desktop for login
	cp $DESKTOP_DIR/Dotfiles/x11/start.sh ~/.config/
	cp $DESKTOP_DIR/dwm/dwm.desktop /usr/share/xsessions/dwm.desktop
}

function conda() {
	wget https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh
	chmod +x Anaconda3-2023.03-1-Linux-x86_64.sh
	./Anaconda3-2023.03-1-Linux-x86_64.sh
}

function ui() {
	# wallpapers and xresouces
	sudo apt install xwallpapers xcompmgr redshift
	cd $DESKTOP_DIR
	git clone https://github.com/makccr/wallpapers.git
	cd ~/.local/share/wallpapers
	ln -s $DESKTOP_DIR/wallpapers wallpapers

	pip install pywal colorz
	changebg
}

function fonts() {
	mkdir ~/.local/share/fonts
	wget https://github.com/ToxicFrog/Ligaturizer/releases/download/v5/LigaturizedFonts.zip
	unzip LigaturizedFonts.zip -d LigaturizedFonts
	mv LigaturizedFonts ~/.local/share/fonts
	rm LigaturizedFonts.zip

	git clone https://github.com/uditkarode/libxft-bgra
	cd libxft-bgra
	sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
	sudo make install

	sudo apt remove fonts-noto-color-emoji
	wget https://raw.githubusercontent.com/Sav22999/emoji/master/font/twemoji-fix-macos.ttf
	mv twemoji-fix-macos.ttf ~/.local/share/fonts

	wget https://raw.githubusercontent.com/Sav22999/emoji/master/font/joypixels.ttf
	mv joypixels.ttf ~/.local/share/fonts

	## set font config 
	mkdir ~/.config/fonts
	cd ~/.config/fonts
	ln -s $DESKTOP_DIR/Dotfiles/fonts/fonts.conf fonts.conf

	## Sarasa mono
	sudo apt install p7zip-full
	cd ~/.local/share/fonts
	wget https://github.com/be5invis/Sarasa-Gothic/releases/download/v0.40.7/sarasa-gothic-super-ttc-0.40.7.7z
	7z x sarasa-gothic-super-ttc-0.40.7.7z
	fc-cache
}

function install_emacs() {
	local version=$1
	sudo apt-get install build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev libncurses-dev automake autoconf
	sudo apt install libtiff-dev libgif-dev libgnutls28-dev libncurses-dev mailutils libgccjit-10-dev libxaw-7-dev libmagic++-dev
	wget http://mirror.freedif.org/GNU/emacs/emacs-${version}.tar.gz
	mv emacs-${version}.tar.gz $HOME/System
	cd $HOME/System
	tar zxvf emacs-${version}.tar.gz
	cd emacs-${version}
    CFLAGS='-march=native -O3' ../configure     --with-modules    --with-mailutils     --with-imagemagick  -C     --with-x-toolkit=lucid
	sudo make install -j 8

#	git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
#	cd ~/.config/
#	ln -s $DESKTOP_DIR/Dotfiles/doom doom
	~/.config/emacs/bin/doom sync -e
}

function cuda() {
	## Need to turn off security boot in bios.
	# install driver
	sudo apt -y install libglvnd-dev pkg-config

	wget https://us.download.nvidia.com/XFree86/Linux-x86_64/525.116.04/NVIDIA-Linux-x86_64-525.116.04.run
	chmod +x NVIDIA-Linux-x86_64-525.116.04.run
	sudo ./NVIDIA-Linux-x86_64-525.116.04.run

	# install cuda
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
	sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
	wget https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda-repo-ubuntu2004-12-1-local_12.1.1-530.30.02-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu2004-12-1-local_12.1.1-530.30.02-1_amd64.deb
	sudo cp /var/cuda-repo-ubuntu2004-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
	sudo apt-get update
	sudo apt-get -y install cuda
}

#install_desktop_apps
install_emacs 29.3
#exit
#dep
#term
#fonts
#ui
#cuda

