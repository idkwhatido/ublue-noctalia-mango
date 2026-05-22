#!/bin/bash

users=$(ls -1 /home/)
mango_src="/etc/skel/.config/mango"
mango_dst=".config/mango"

for user in ${users[@]}; do
    if [[ $user == "linuxbrew" ]]; then
        continue
    fi
    if [ ! -d "/home/$user/$mango_dst" ]; then
        cp -r /etc/skel/.config/mango /home/$user/$mango_dst
        chown -R $user:$user /home/$user/$mango_dst
    fi
done
