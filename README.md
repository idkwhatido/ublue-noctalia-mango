# ublue-noctalia-mango
## Disclaimer
This is my first Image and i am sure it is not perfect and there are ways to do things way better.

## Description
This is my customized ublue image, based of aurora.
I created it, because i wanted MangoWM with Noctalia-Shell and some other programs preinstalled.

## What is customized?
To begin i removed KDE and SDDM and added the following:
- MangoWM (Desktop Environment)
- greetd (Login Manager)
- sysc-greet (Frontend for the Login Manager)
- Yazi (Terminal based File-Manager)
- Firefox (Default Web-Browser)
- Noctalia-Shell

## Can i try it out?
Of course, the generated Image is a Live-Image so you can try it out before having to install it.
The Login for the Live-Environment is "live" (both user and password)

## How do i change the Keyboard Layout???
Open the file `~/.config/mango/config.conf` and search for `xkb`. With default settings there is a line that specify the keyboard layouts `en,ru`, simply change that to your desired layout and press `SUPER+R` to reload the configuration.

## Where can i download the iso?
You can download the iso from [here](https://ublue-images.s3.de.io.cloud.ovh.net/ublue-noctalia-mango-latest-webui-x86_64.iso)<br>
The Checksum-File can be downloaded [here](https://ublue-images.s3.de.io.cloud.ovh.net/ublue-noctalia-mango-latest-webui-x86_64.iso-CHECKSUM)

## Known Bugs
- At first login after install noctalia-shell won't load -> i have a idea why, but have to test the possible fix

## Roadmap
- Fix the bugs
- Modify the Justfile (remove some options and add some own)
- Make a decision if i want to remove firefox as system package
- Be happy
