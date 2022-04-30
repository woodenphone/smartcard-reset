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


Show only secret subkeys:
```
gpg --batch --with-colons --list-secret-keys | grep '^ssb:'
```
* `- ssb :: Secret subkey (secondary key)`


Show ID of expected smartcard:
```
$ gpg --batch --with-colons --list-secret-keys | grep '^ssb:' | cut --delimiter=':' --fields=15 --only-delimited

$ gpg --batch --with-colons --list-secret-keys | cut --delimiter=':' --fields=15 --only-delimited | grep '[[:alnum:]]'
```
* `*** Field 15 - S/N of a token` See: GNUPG source code `/doc/DETAILS`


## Links
### PCSCD
* `pcscd`
* https://linux.die.net/man/8/pcscd

### Misc
* https://linux.die.net/man/3/syslog
* https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs
* https://www.man7.org/linux/man-pages/man1/journalctl.1.html