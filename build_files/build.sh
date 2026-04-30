#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# install some base packages
dnf5 install -y ghostty usbguard usbguard-selinux usbguard-notifier git wget curl

# install podman
dnf5 install -y podman

# install distrobox
dnf5 install -y distrobox

# install mangowm, dotfiles and noctalia shell
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf5 install -y mangowm
mkdir -p /etc/skel/.config
dnf5 install -y rofi ghostty xdg-desktop-portal-wlr swaybg cliphist wl-clipboard wlsunset xfce-polkit swaync pamixer  sway-audio-idle-inhibit swayidle brightnessctl swayosd wlr-randr grim slurp satty swaylock-effects wlogout sox
git clone https://github.com/DreamMaoMao/mango-config.git /etc/skel/.config/mango
dnf5 install -y noctalia-shell
sed -i 's/waybar -c.*/qs -c noctalia-shell >\/dev\/null 2>\&1 \&/g'

# install login management
dnf5 install -y greetd
wget https://github.com/Nomadcxx/sysc-greet/releases/download/v1.1.6/sysc-greet-1.1.6-1.x86_64.rpm
dnf5 install -y ./sysc-greet-1.1.6-1.x86_64.rpm
systemctl enable greetd

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
