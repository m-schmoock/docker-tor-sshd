#!/bin/sh

/usr/bin/ssh-keygen -A

# check if root has password defined

if grep -q ^root:*: /etc/shadow; then
	echo "Setting random password for user root"
	RND=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
	echo root:$RND | chpasswd
	echo
	echo "Random password for root user: $RND"
	echo
fi

rm -f /var/log/tor/notices.log

sed -e s/PORT_TO_REPLACE/$SSH_PORT/ /etc/tor/torrc.tpl > /etc/tor/torrc

s6-setuidgid tor tor --runasdaemon 1

echo "Waiting for tor:"
while ! grep -qF 'Bootstrapped 100% (done): Done' /var/log/tor/notices.log
do
  sleep 1
  echo -n .
done
echo " Done."

echo
echo "Add this to your ~/.ssh/config:"
echo
echo "	Host *.onion"
echo "		ProxyCommand torsocks nc %h %p"
echo
echo
echo "Conenct using the generated password shown above via:>  ssh root@$(cat /var/lib/tor/hidden_service/hostname)"
echo "Use this to copy your ssh pubkey:>  ssh-copy-id root@$(cat /var/lib/tor/hidden_service/hostname)"
echo "Feel free to use local port forwarding to access web GUIs, e.g. via:> ssh -F 8080:192.168.0.123:80 ..."
echo

exec "$@"
