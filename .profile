export QT_QPA_PLATFORMTHEME="qt5ct"
#export EDITOR=/usr/bin/vim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/firefox

export PATH=~/.yarn/bin:$PATH

# setcalibre to use dark mode
export CALIBRE_USE_DARK_PALETTE=1

# IME
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# wayland
export MOZ_ENABLE_WAYLAND=1 # firefox
export QT_QPA_PLATFORM=wayland-egl # qt5
export ECORE_EVAS_ENGINE=wayland_egl # Elementary/EFL
export ELM_ENGINE=wayland_egl
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
