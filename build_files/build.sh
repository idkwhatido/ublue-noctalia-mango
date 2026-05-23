#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# remove KDE and SDDM
dnf5 remove -y dolphin ark konsole filelight kde-connect kde-connect-* kdebugsettings spectacle kwrite Sunshine ptyxis kinfocenter rofi rofi-*
dnf5 remove -y kde-* plasma-*
dnf5 remove -y sddm sddm-*

# install some base packages
dnf5 install -y usbguard usbguard-selinux usbguard-notifier git wget curl kitty

# install podman
dnf5 install -y podman

# install distrobox
dnf5 install -y distrobox

# install mangowm, dotfiles and noctalia shell
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf5 install -y mangowm
mkdir -p /etc/skel/.config
dnf5 install -y ghostty xdg-desktop-portal-wlr swaybg cliphist wl-clipboard wlsunset xfce-polkit swaync pamixer  sway-audio-idle-inhibit swayidle brightnessctl swayosd wlr-randr grim slurp satty swaylock-effects wlogout sox fd-find
git clone https://github.com/DreamMaoMao/mango-config.git /etc/skel/.config/mango
sed -i 's/env=GTK_IM.*/#env=GTK_IM_MODULE,fcitx/g' /etc/skel/.config/mango/env.conf
dnf5 install -y noctalia-shell
sed -i 's/waybar -c.*/qs -c noctalia-shell >\/dev\/null 2>\&1 \&/g' /etc/skel/.config/mango/autostart.sh
sed -i 's/bind=Alt,Return.*/bind=Alt,Return,spawn,ghostty/g' /etc/skel/.config/mango/bind.conf
sed -i 's/bind=Alt,space.*/bind=Alt,space,spawn,qs -c noctalia-shell ipc call launcher toggle/g' /etc/skel/.config/mango/bind.conf
sed -i 's/bind=SUPER+SHIFT,p.*/bind=SUPER+SHIFT,p,spawn,qs -c noctalia-shell ipc call sessionMenu toggle/g' /etc/skel/.config/mango/bind.conf
echo "# custom added bindings" >> /etc/skel/.config/mango/bind.conf
echo "bind=SUPER,b,spawn,flatpak run org.mozilla.firefox" >> /etc/skel/.config/mango/bind.conf
echo "bind=SUPER,f,spawn,ghostty -e yazi" >> /etc/skel/.config/mango/bind.conf


# install login management
dnf5 install -y greetd
wget https://github.com/Nomadcxx/sysc-greet/releases/download/v1.1.6/sysc-greet
mkdir /usr/share/sysc-greet
mv ./sysc-greet /usr/share/sysc-greet/
chmod +x /usr/share/sysc-greet/sysc-greet
chown greetd:greetd /usr/share/sysc-greet/sysc-greet

mkdir -p /usr/share/sysc-greet/{ascii_configs,fonts,wallpapers}
cp /ctx/greeter-ascii/ascii_configs/* /usr/share/sysc-greet/ascii_configs/
cp /ctx/greeter-ascii/fonts/* /usr/share/sysc-greet/fonts/
cp /ctx/greeter-ascii/wallpapers/* /usr/share/sysc-greet/wallpapers/
cp /ctx/greeter-ascii/kitty-greeter.conf /etc/greetd/kitty.conf

rm -f /usr/share/applications/kitty.desktop
rm -f /usr/share/applications/kitty-open.desktop

mkdir /usr/share/sysc-greet/mango-greet
cp /ctx/greeter-ascii/config.conf /usr/share/sysc-greet/mango-greet/config.conf
cp /ctx/greeter-ascii/env.conf /usr/share/sysc-greet/mango-greet/env.conf
/usr/bin/cp /ctx/greeter-ascii/config.toml /etc/greetd/config.toml

mkdir /tmp/greetd-fix
cp /ctx/greeter-ascii/greetd-fix.* /tmp/greetd-fix/
semodule -i /tmp/greetd-fix/greetd-fix.pp

systemctl enable greetd

# disable terra gpg check to avoid build error
sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/terra.repo

dnf5 -y copr enable lihaohong/yazi
dnf5 install -y yazi
rm -f /usr/share/applications/yazi.desktop

# remove some default aurora stuff
rm -f /usr/share/applications/dev.getaurora.*
rm -rf /usr/share/doc/aurora


# cleanup
dnf5 autoremove -y

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

# set gtk dark theme as default
tee /usr/share/glib-2.0/schemas/zzzzzzz-default-dark.gschema.override <<EOF
[org.gnome.desktop.interface]
color-scheme='prefer-dark'
gtk-theme='Breeze'
EOF
glib-compile-schemas /usr/share/glib-2.0/schemas/

# install mango-helper to prevent shell issues
mkdir /usr/share/mango-helper
cp /ctx/mango-fix/ensure_mango.sh /usr/share/mango-helper/ensure_mango.sh
chmod +x /usr/share/mango-helper/ensure_mango.sh
cp /ctx/mango-fix/ensure_mango.service /usr/lib/systemd/system/ensure_mango.service

systemctl enable /usr/lib/systemd/system/ensure_mango.service

# ujust mods
rm -f /usr/share/ublue-os/just/changelog.just
rm -f /usr/share/ublue-os/just/system.just
sed -i 's/import \"\/usr\/share\/ublue-os\/just\/changelog.just\"//g' /usr/share/ublue-os/just/00-entry.just
sed -i 's/import \"\/usr\/share\/ublue-os\/just\/system.just\"//g' /usr/share/ublue-os/just/00-entry.just
echo 'import "/usr/share/ublue-os/just/ui.just"' >> /usr/share/ublue-os/just/00-entry.just
echo 'import "/usr/share/ublue-os/just/usbguard.just"' >> /usr/share/ublue-os/just/00-entry.just
cp /ctx/just_files/*.just /usr/share/ublue-os/just/

# modify image-info.json
sed -i 's/"image-name".*/"image-name: "aurora-manoc",/g' /usr/share/ublue-os/image-info.json
sed -i 's/"image-vendor".*/"image-vendor: "idkwhatido",/g' /usr/share/ublue-os/image-info.json
sed -i 's/"image-ref".*/"image-ref: "ostree-image-signed:\/\/ghcr.io\/idkwhatido\/ublue-noctalia-mango",/g' /usr/share/ublue-os/image-info.json

# fix xdg-desktop-portal
sed -i 's/RefuseManualStart=yes/RefuseManualStart=no/g' /usr/lib/systemd/user/graphical-session.target
sed -i 's/StopWhenUnneeded=yes//g' /usr/lib/systemd/user/graphical-session.target
echo "systemctl --user start graphical-session.target" >> /etc/skel/.config/mango/autostart.sh
