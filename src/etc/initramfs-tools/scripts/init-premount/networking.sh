#!/bin/sh

PREREQ="udev"

prereqs() {
    echo "$PREREQ"
}

case "$1" in
    prereqs)
        prereqs
        exit 0
    ;;
esac

. /scripts/functions

# Network is manually configured.
[ "$IP" != off ] && [ "$IP" != none ] || exit 0

# Always run configure_networking() before fetching the key; on NFS 
# mounts this has been already done
[ "$BOOT" != nfs ] && configure_networking

# Waiting a moment to get a valid network connection before 
# configuring resolv.conf
connection_wait=30
seconds=0
while [ $seconds -le $connection_wait ]; do
    if [ "$(/sbin/ip addr | grep -c inet )" -ne 0 ]; then
        break
    fi
    if [ $seconds -ge $connection_wait ]; then
        log_failure_msg "No working networking connection found in $connection_wait seconds"
    fi
    sleep 1
    seconds=$(( seconds + 1))
done

# Configure a basic resolv.conf just to get domain name resolving
# working.
if ! [ -s /etc/resolv.conf ]; then
    # Use Cloudflare dns resolver if no dns resolver is supplied
    if [ -z "$IPV4DNS0" ]; then
        IPV4DNS0="1.1.1.1"
    fi
    echo "nameserver $IPV4DNS0" > /etc/resolv.conf
fi
