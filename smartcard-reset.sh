#! /bin/bash
## smartcard-reset.sh
## USAGE: $ sudo ./smartcard-reset.sh
## Install to: /usr/local/bin/smartcard-reset.sh

sc_user=${1:-${USER}} # Reassociate smartcard with proper user
echo "# sc_user=$sc_user"

## Check for present USB smartcards.
## Exit if no smartcard is plugged in.
usb_cards_present="$(lsusb | grep 'Yubi')"
echo "## usb_cards_present=${usb_cards_present@Q}"

if [ -z "$usb_cards_present" ] # If string length is zero
then
  echo "No USB devices detected, no point doing any work. Exiting."
  exit
else # If string length is not zero
  echo "Found USB smartcard"
fi

## Check if smartcard is seen by GPG.
## Reset pscsd if card not found.
## https://github.com/gpg/gnupg/blob/master/doc/DETAILS
gpg_sc_status="$( gpg --batch --with-colons --card-status )"
#echo "## gpg_sc_status=" "${gpg_sc_status@Q}"
if [ -n "$gpg_sc_status" ] ; then
  echo "GPG cant see smartcard. Restarting pcscd service."
  #systemctl status pcscd
  systemctl restart pcscd
  #systemctl status pcscd
fi





## Re-learn smartcard/key association
echo "Re-learning smartcard/key pairing"
# Reassociate smartcard with proper user
sudo -u ${sc_user} gpg-connect-agent "scd serialno" "learn --force" /bye

echo "Script exiting"
exit
