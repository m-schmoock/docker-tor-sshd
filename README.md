# TOR SSHD container
This container starts a SSH service accessible via a TOR hidden service identifier. This is particularly useful when operating behind carrier NATs (CGNAT). Can also be used with port fowarding options, to make web GUIs accessible in such scenarios.

1. Run the container with no special configs required
2. Get the root password as well as the hidden service id ( .onion address) from the container logs.
3. If you want, you should then copy your SSH pubkeys via ssh-copy-id into the container, so you don't need to write down the stupid password.
4. Add any helpful port forwardings to access local GUIs, e.g. `ssh -L 8080:192.168.0.1:80 root@...onion`.
5. Call it a day.
