# enroll usbguard
enroll-usbguard:
    usbguard generate-policy > /tmp/usbguard_rules.conf
    sudo mv /tmp/usbguard_rules.conf /etc/usbguard/rules.conf
    sudo chown root:root /etc/usbguard/rules.conf
    sudo chmod 0600 /etc/usbguard/rules.conf
    sudo chcon system_u:object_r:usbguard_conf_t:s0 /etc/usbguard/rules.conf
    sudo systemctl start usbguard
    echo "USBGuard is configured and enabled for this boot."
    echo "To enable USBGuard permanently enter the following command (pls test before):"
    echo "sudo systemctl enable usbguard"
