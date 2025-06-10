FROM ubuntu:24.04

COPY setup /tmp/setup

# Install OpenSSH Server itself and preinstall packages for AmneziaVPN
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y bash sudo openssh-server libgcrypt20 lsof psmisc && \
    # settings for SSH-daemon
    cd /etc/ssh && \
    rm ssh_host_ecdsa_key ssh_host_ecdsa_key.pub ssh_host_ed25519_key ssh_host_ed25519_key.pub ssh_host_rsa_key ssh_host_rsa_key.pub && \
    mkdir /var/run/sshd && \
    mv /tmp/setup/00-standard.conf /etc/ssh/sshd_config.d/ && \
    chmod +x /tmp/setup/*.sh && \
    # preinstall packages for docker.io
    DEBIAN_FRONTEND=noninteractive /tmp/setup/install-docker.sh && \
    rm /tmp/setup/install-docker.sh && \
    # Disable SSH-daemon autostart
    touch /etc/ssh/sshd_not_to_be_run && \
    chmod 0644 /etc/ssh/sshd_not_to_be_run && \
    echo 'root:password' | chpasswd

EXPOSE 22

# Starting SSH-daemon
ENTRYPOINT ["/bin/bash", "-c", "--"]
CMD ["/tmp/setup/start.sh"]

# only for the debug purpose
# RUN DEBIAN_FRONTEND=noninteractive apt install -y mc nano screen htop net-tools
