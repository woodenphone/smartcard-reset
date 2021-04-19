# smartcard-reset
Simple utility to fix an issue where after a reboot a USB smartcard is not recognized until removed and reinserted.

It just restarts pcscd and then tells GPG to re-learn the smartcard association.

I wrote this becase it was annoying to have to reinsert my smartcard after a reboot.

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
2. Change the username in the service to  your linux username.
3. Run the playbook:
```
$ sudo ansible-playbook smartcard-reset.playbook.yml
```


### Manually
1. Put files in correct locations:
```
$ sudo cp smartcard-reset.sh /usr/local/bin/smartcard-reset.sh
$ sudo cp smartcard-reset.timer smartcard-reset.timer
$ sudo cp smartcard-reset.service '/etc/systemd/system/smartcard-reset.service'
$ sudo chown 'o=rwx,g=rwx,o=r' smartcard-reset.timer '/etc/systemd/system/smartcard-reset.service' '/usr/local/bin/smartcard-reset.sh'
```

2. Schedule to run:
```
$ sudo systemctl enable smartcard-reset.timer smartcard-reset.service
```


## Notes
It may be required to use sudo to run as root to install locally (localhost).

This does not currently bother to work for non-yubikey smartcards, even though it should be trivial to detect and handle them too.


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