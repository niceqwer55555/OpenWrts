#!/bin/sh
#supports_backup in PINN

# This is just the default partition_setup.sh from Raspbian Full
# Adapt as appropriate
#cd /data/111/test2
#kpartx -av openwrt-bcm27xx-bcm2710-rpi-3-ext4-factory.img
#输出IMG内部两个分区：

#add map loop7p1 (253:0): 0 125000 linear 7:0 1
#add map loop7p2 (253:1): 0 14209047 linear 7:0 125001

# 新建三个目录
mkdir usb1
mkdir usb2
mkdir raspios_arm64

# 挂载分区
mount -o loop,ro,noexec /dev/mapper/loop7p1 usb1
mount -o loop,ro,noexec,noload /dev/mapper/loop7p2 usb2
#sudo mount /dev/mapper/loop4p1 usb1
#sudo mount /dev/mapper/loop4p2 usb2

cd usb1
bsdtar --numeric-owner --format gnutar  -cvpf ../raspios_arm64/boot.tar .
#tar --numeric-owner -cvpf ../raspios_arm64/boot.tar .
cd ..
xz -9 -ev raspios_arm64/boot.tar

cd usb2
bsdtar --numeric-owner --format gnutar --one-file-system -cpvf ../raspios_arm64/root.tar .
#sudo tar --numeric-owner --one-file-system --format gnu -cvpf ../raspios_arm64/root.tar .
cd ..
xz -9 -ev raspios_arm64/root.tar

cd raspios_arm64
sha512sum boot.tar.xz
sha512sum root.tar.xz
sudo xz -l boot.tar.xz
sudo xz -l root.tar.xz

kpartx -dv openwrt-bcm27xx-bcm2710-rpi-3-ext4-factory.img

losetup -d /dev/loop7p1 /dev/loop7p2
#umount /dev/loop27