#!/bin/ash

# create a user for other then 'root'
__create_user() {
   # Create a user for SSH
   adduser -D --shell /bin/ash $SSH_USERNAME
   echo "remote:$SSH_USERPASS" | chpasswd &>/dev/null
   # Add new user to group 'wheel'
   adduser $SSH_USERNAME wheel
   echo "ssh username: $SSH_USERNAME"
   echo "ssh password: $SSH_USERPASS"
}

# add a banner to OpenSSH
__add_banner() {
   # add different variables in the banner
   HARDWARE=`uname -m`
   KERNEL=`uname -r`
   sed -i s/HARDWARE/$HARDWARE/ /etc/ssh/banner
   sed -i s/KERNEL/$KERNEL/ /etc/ssh/banner
   sed -i s/HOSTNAME/$HOSTNAME/ /etc/ssh/banner

   # add the username & password in the banner
   sed -i "s/USERNAME:.*/USERNAME:\ $SSH_USERNAME/"	 /etc/ssh/banner
   sed -i "s/PASSWORD:.*/PASSWORD:\ $SSH_USERPASS"/ /etc/ssh/banner
   # permit 'root' account in OpenSSH
   sed -i 's/#Banner.*/Banner\ \/etc\/ssh\/banner/' /etc/ssh/sshd_config
}

# generate host keys if not present
ssh-keygen -A &>/dev/null

# username
SSH_USERNAME=remote
# generate random password for username "$SSH_USERNAME"
SSH_USERPASS=$(dd if=/dev/urandom bs=1 count=15 | base64) &>/dev/null

__create_user

# add a banner to OpenSSH
__add_banner

# sudo configuration for "SSH_USERNAME"
echo "$SSH_USERNAME ALL=(ALL) ALL" > /etc/sudoers.d/$SSH_USERNAME && chmod 0440 /etc/sudoers.d/$SSH_USERNAME

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"
