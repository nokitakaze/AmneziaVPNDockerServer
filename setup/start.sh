#!/bin/bash

# Checking ssh keys
cd /etc/ssh
if [ ! -f /etc/ssh/server-keys/ssh_host_ecdsa_key ]; then
  echo "File /etc/ssh/server-keys/ssh_host_ecdsa_key does not exist. Setup SSH host keys..."
  ssh-keygen -A
  cp ssh_host_ecdsa_key server-keys/
  cp ssh_host_ecdsa_key.pub server-keys/
  cp ssh_host_ed25519_key server-keys/
  cp ssh_host_ed25519_key.pub server-keys/
  cp ssh_host_rsa_key server-keys/
  cp ssh_host_rsa_key.pub server-keys/
else
  cd /etc/ssh/server-keys
  cp ssh_host_ecdsa_key ../
  cp ssh_host_ecdsa_key.pub ../
  cp ssh_host_ed25519_key ../
  cp ssh_host_ed25519_key.pub ../
  cp ssh_host_rsa_key ../
  cp ssh_host_rsa_key.pub ../
fi

# Launches the OpenSSH daemon in foreground mode (-D) and directs all log output to stderr (-e)
/usr/sbin/sshd -D -e
