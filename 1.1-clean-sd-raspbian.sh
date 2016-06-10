#!/bin/sh
echo "Runnning fdisk -l to list your disks"
fdisk-l
echo "Which disk do you want this to run against?  Remember, it'll get wiped!"
read hdd
hdd="/dev/sdb"
umount "$(echo $hdd)1"
umount "$(echo $hdd)2"

mkdir -p /root/rpi
cd /root/rpi

echo "o
p
n
p
1

+100M
t
c
n
p
2


w" | fdisk $hdd
mkfs.vfat "$(echo $hdd)1"
mkdir -p /root/rpi/boot
kpart
mount "$(echo $hdd)1" /root/rpi/boot

mkfs.ext4 "$(echo $hdd)2"
mkdir -p /root/rpi/root
kpart
mount "$(echo $hdd)2" /root/rpi/root

if [! -f 2016-03-18-raspbian-jessie-lite.zip]; then
  unzip 2016-03-18-raspbian-jessie-lite.zip -d /root/rpi/root
else
  wget https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2016-03-18/2016-03-18-raspbian-jessie-lite.zip
  unzip 2016-03-18-raspbian-jessie-lite.zip -d /root/rpi/root
fi

sync
mv /root/rpi/root/boot/* /root/rpi/boot

umount /root/rpi/boot /root/rpi/root
