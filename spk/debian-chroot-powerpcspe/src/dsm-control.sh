#!/bin/sh

# Package
PACKAGE="debian-chroot-powerpcspe"
DNAME="Debian Chroot PowerPC-SPE"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
CHROOTTARGET=`realpath ${INSTALL_DIR}/var/chroottarget`


start_daemon ()
{
    # Mount if install is finished
    if [ -f ${INSTALL_DIR}/var/installed ]; then
        # Make sure we don't mount twice
        grep -q "${CHROOTTARGET}/proc " /proc/mounts || mount -t proc proc ${CHROOTTARGET}/proc
        grep -q "${CHROOTTARGET}/sys " /proc/mounts || mount -t sysfs sys ${CHROOTTARGET}/sys
        grep -q "${CHROOTTARGET}/dev " /proc/mounts || mount -o bind /dev ${CHROOTTARGET}/dev
        grep -q "${CHROOTTARGET}/dev/pts " /proc/mounts || mount -o bind /dev/pts ${CHROOTTARGET}/dev/pts
        
        # Start all services
        ${INSTALL_DIR}/app/start.py
    fi
}

stop_daemon ()
{
    # Stop running services
    ${INSTALL_DIR}/app/stop.py

    # Unmount
    umount ${CHROOTTARGET}/dev/pts
    umount ${CHROOTTARGET}/dev
    umount ${CHROOTTARGET}/sys
    umount ${CHROOTTARGET}/proc
}

daemon_status ()
{
    `grep -q "${CHROOTTARGET}/proc " /proc/mounts` && `grep -q "${CHROOTTARGET}/sys " /proc/mounts` && `grep -q "${CHROOTTARGET}/dev " /proc/mounts` && `grep -q "${CHROOTTARGET}/dev/pts " /proc/mounts`
}


case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit 0
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    chroot)
        # Pass the ssh-agent to the chroot
        if [ -e ${SSH_AUTH_SOCK} ]; then
            mkdir -p ${CHROOTTARGET}/$(dirname "${SSH_AUTH_SOCK}")
            mount -o bind $(dirname "${SSH_AUTH_SOCK}") ${CHROOTTARGET}/$(dirname "${SSH_AUTH_SOCK}")
        fi
        
        # Use the ssh-agent in the chroot
        chroot ${CHROOTTARGET}/ /usr/bin/env -i SHELL="/bin/bash" TERM="$TERM" SSH_AUTH_SOCK="$SSH_AUTH_SOCK" /bin/bash
        
        # Remove the ssh-agent on exit
        if [ -e ${CHROOTTARGET}/$(dirname "${SSH_AUTH_SOCK}") ]; then
            umount ${CHROOTTARGET}/$(dirname "${SSH_AUTH_SOCK}")
            rmdir ${CHROOTTARGET}/$(dirname "${SSH_AUTH_SOCK}")
        fi
        ;;
    *)
        exit 1
        ;;
esac
