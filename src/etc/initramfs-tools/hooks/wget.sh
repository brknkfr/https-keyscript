#!/bin/sh -e
PREREQS=""
case $1 in
        prereqs) echo "${PREREQS}"; exit 0;;
esac
. /usr/share/initramfs-tools/hook-functions

# To find out what library are needed do
# strace busybox wget https://badssl.com 2>&1 | grep open
for library in "libnss_dns.*" "libnss_files.so.*" "libresolv.so.*" "ld-linux-*.so.*" "libc.so.*"
do
	find /lib/ -name '$library' -type f
	copy_exec "$library"
done

copy_exec /etc/ssl/certs/ca-certificates.crt
