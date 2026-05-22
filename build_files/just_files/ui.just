# toggle gtk dark mode
gtk-toggle-dark:
    current_prefer=$(gsettings get org.gnome.desktop.interface color-scheme)
    if [[ $current_prefer == "'prefer-dark'" ]]; then
        gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
        flatpak override --user --env=GTK_THEME=Adwaita:dark
    else
        gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        flatpak override --user --env=GTK_THEME=Adwaita:light
    fi

aurora-cli:
    @ublue-bling
    brew bundle --file=/usr/share/ublue-os/homebrew/cli.Brewfile
