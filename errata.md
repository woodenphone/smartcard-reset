# Eratta
Miscelanious notes and such.


## Handy commands
Relearn smartcard
```
$ gpg-connect-agent  "scd serialno" "learn --force" /bye
```

Relearn smartcard silent and non-blocking:
```
$ $(gpg-connect-agent  "scd serialno" "learn --force" /bye  >/dev/null 2>/dev/null) &
```

## Links
### PCSCD
* `pcscd`
* https://linux.die.net/man/8/pcscd

### Misc
* https://linux.die.net/man/3/syslog
* https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs
* https://www.man7.org/linux/man-pages/man1/journalctl.1.html