# Inpired by https://github.com/raesene and https://github.com/sickp.
# Build: docker build -t sshd .

FROM alpine:3.17.1
LABEL maintainer "daniel@isociel.com"
EXPOSE 22

COPY banner /etc/ssh/
COPY motd /etc/
COPY entrypoint.sh /

# The following line is to prevent the error:
# Make the script 'executable'. Prevents the error: permission denied unknown
RUN ["chmod", "+x", "/entrypoint.sh"]

# RUN apk update --no-cache
# RUN apk --update add bind-tools && rm -rf /var/cache/apk/*

# OpenSSH installation, permit "root" and set "root" password.
RUN apk add --no-cache openssh \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd

# Networking package installation
RUN apk add --no-cache busybox-extras sudo iputils curl iproute2 nmap tcpdump nmap-ncat iperf socat

ENTRYPOINT ["/entrypoint.sh"]
