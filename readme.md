# smartcard-reset
Simple utility to fix an issue where after a reboot a USB smartcard is not recognized until removed and reinserted.

It just restarts pcscd and then tells GPG to re-learn the smartcard association.

I wrote this becase it was annoying to have to reinsert my smartcard after a reboot.

The udev rule should trigger GPG to relearn the smartcard after plugging it in.


## Manual usage
Running the script just once.

Invoke the script via sudo:
```
$ chmod -v +x ./smartcard-reset.sh
$ sudo ./smartcard-reset.sh USERNAME
```


## Install
Making the script autorun.

### Via ansible
1. Change the username in the playbook to your linux username.
2. Run the playbook:
```
$ ansible-playbook smartcard-reset.playbook.yml
```


### Manually
1. Put files in correct locations:
```
$ sudo cp -v 'files/smartcard-reset.sh' '/usr/local/bin/smartcard-reset.sh'

$ sudo cp -v 'files/80-yubikey-actions.rules' '/etc/udev/rules.d/80-yubikey-actions.rules'

$ sudo cp -v 'files/smartcard-reset.timer' 'smartcard-reset.timer'
$ sudo cp -v 'files/smartcard-reset.service' '/etc/systemd/system/smartcard-reset.service'

$ sudo chown -v 'o=rwx,g=rwx,o=r' smartcard-reset.timer '/etc/systemd/system/smartcard-reset.service' '/usr/local/bin/smartcard-reset.sh'
```

2. Set user to act on in the service file:

```$ sudo nano /etc/systemd/system/smartcard-reset.service```
```
ExecStart=/usr/local/bin/smartcard-reset.sh "some-user"
```

3. Reload udev rules (optional):
```
$ sudo udevadm control --reload-rules
```
Optionally force rules to be run right now:
```
$ sudo udevadm trigger --attr-match=vendor='Yubico'
```
* udev should normally not need either of these and just detect that a file in its config dirs was changed on its own.

4. Schedule to run:
```
$ sudo systemctl daemon-reload # Make systemd notice changed config files.
$ sudo systemctl enable smartcard-reset.timer smartcard-reset.service
```

5. Manually run (if desired):
```
$ sudo systemctl start smartcard-reset.service
```
or
```
$ sudo /usr/local/bin/smartcard-reset.sh "some-user"
```


## Testing
Check playbook:
```
$ ansible-playbook smartcard-reset.playbook.yml --syntax-check

$ ansible-playbook smartcard-reset.playbook.yml --check
```

* I dont have a viable automated testing methodology for this beyond the playbook running.


## Notes
It may be required to use sudo to run as root to install locally (localhost).

This does not currently bother to work for non-yubikey smartcards, even though it should be trivial to detect and handle them too.


## Debugging and troubleshooting
```
# journalctl -b --unit=smartcard-reset.service
```


## Links
* https://wiki.archlinux.org/index.php/Systemd/Timers
* https://man.archlinux.org/man/systemd.unit.5.en
* https://man.archlinux.org/man/systemd.timer.5.en
* https://man.archlinux.org/man/systemd.time.7
* https://wiki.archlinux.org/index.php/Systemd
* https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files
* https://unix.stackexchange.com/questions/226535/where-do-i-put-scripts-executed-by-systemd-units
* https://linux.die.net/man/3/syslog
* https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs
* https://www.man7.org/linux/man-pages/man1/journalctl.1.html
* https://linux.die.net/man/8/pcscd
* https://github.com/drduh/YubiKey-Guide
* https://unix.stackexchange.com/questions/39370/how-to-reload-udev-rules-without-reboot