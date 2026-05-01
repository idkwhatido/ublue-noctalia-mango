#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# remove KDE and SDDM
dnf5 remove -y dolphin ark konsole filelight kde-connect kde-connect-* kdebugsettings spectacle kwrite Sunshine ptyxis kinfocenter
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
dnf5 install -y rofi ghostty xdg-desktop-portal-wlr swaybg cliphist wl-clipboard wlsunset xfce-polkit swaync pamixer  sway-audio-idle-inhibit swayidle brightnessctl swayosd wlr-randr grim slurp satty swaylock-effects wlogout sox fd-find firefox
git clone https://github.com/DreamMaoMao/mango-config.git /etc/skel/.config/mango
dnf5 install -y noctalia-shell
sed -i 's/waybar -c.*/qs -c noctalia-shell >\/dev\/null 2>\&1 \&/g' /etc/skel/.config/mango/autostart.sh
sed -i 's/bind=Alt,Return.*/bind=Alt,Return,spawn,ghostty/g' /etc/skel/.config/mango/bind.conf
echo "# custom added bindings" >> /etc/skel/.config/mango.bind.conf
echo "bind=SUPER,b,spawn,firefox" >> /etc/skel/.config/mango/bind.conf
echo "bind=SUPER,f,spawn,ghostty -e yazi" >> /etc/skel/.config/mango/bind.conf



# install login management
dnf5 install -y greetd
wget https://github.com/Nomadcxx/sysc-greet/releases/download/v1.1.6/sysc-greet
mv ./sysc-greet /var/lib/greetd/
chmod +x /var/lib/greetd/sysc-greet
chown greetd:greetd /var/lib/greetd/sysc-greet

mkdir -p /usr/share/sysc-greet/{ascii_configs,fonts,wallpapers}
cp /ctx/greeter-ascii/ascii_configs/* /usr/share/sysc-greet/ascii_configs/
cp /ctx/greeter-ascii/fonts/* /usr/share/sysc-greet/fonts/
cp /ctx/greeter-ascii/wallpapers/* /usr/share/sysc-greet/wallpapers/
cp /ctx/greeter-ascii/kitty-greeter.conf /etc/greetd/kitty.conf

rm -f /usr/share/applications/kitty.desktop
rm -f /usr/share/applications/kitty-open.desktop

mkdir /var/lib/greetd/mango-greet
cp /ctx/greeter-ascii/config.conf /var/lib/greetd/mango-greet/config.conf
cp /ctx/greeter-ascii/env.conf /var/lib/greetd/mango-greet/env.conf
/usr/bin/cp /ctx/greeter-ascii/config.toml /etc/greetd/config.toml

mkdir /tmp/greetd-fix
cp /ctx/greeter-ascii/greetd-fix.* /tmp/greetd-fix/
semodule -i /tmp/greetd-fix/greetd-fix.pp

systemctl enable greetd

# disable terra gpg check to avoid build error
sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/terra.repo

dnf5 -y copr enable lihaohong/yazi
dnf5 install -y yazi

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
