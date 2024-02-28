FROM alpine:3.19.1

RUN apk add --no-cache openssh-server tor s6
RUN grep -v AllowTcpForwarding /etc/ssh/sshd_config >> /etc/ssh/sshd_config.new
RUN echo PermitRootLogin yes >> /etc/ssh/sshd_config.new
RUN echo AllowTcpForwarding yes >> /etc/ssh/sshd_config.new
RUN mv /etc/ssh/sshd_config.new /etc/ssh/sshd_config

COPY entry.sh /entry.sh
COPY torrc.tpl /etc/tor/torrc.tpl

ENV TOR_PORT 22

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
