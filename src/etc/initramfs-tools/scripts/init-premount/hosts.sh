#!/bin/sh

PREREQ="networking.sh"

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

# 20201113: sl: Somehow dns resolving is not working in initramfs
if ! [ -s /etc/hosts ]; then
    echo "192.168.11.16 luks.atelierrandweg.ch" > /etc/hosts
fi

