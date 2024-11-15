#!/bin/sh


#refer:
#  https://gist.github.com/oznu/ac9efae7c24fd1f37f1d933254587aa4
#  https://gist.github.com/robertkirkman/f79441c79811ad263f2f881f7864e793


# Fix hardware-cursor-rendering-related issue 
# /etc/X11/xorg/conf.d/20-swcursor.conf
#   Section "Device"
#       Identifier "card0"
#       Driver "modesetting"
#       Option "SWcursor" "on"
#   EndSection


# wget https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-arm64-uefi1.img
# wget https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd

# dd if=/dev/zero of=flash0.img bs=1M count=64
# dd if=QEMU_EFI.fd of=flash0.img conv=notrunc
# dd if=/dev/zero of=flash1.img bs=1M count=64

# qemu-img create -f qcow2 image.qcow2 60G


BASEDIR=$(realpath $(dirname $0))


qemu-system-aarch64 \
	-M virt \
	-m 2048 \
	-accel kvm \
	-cpu host \
	-smp 2 \
	-drive if=pflash,media=disk,format=raw,cache=writethrough,file=flash0.img \
	-drive if=pflash,media=disk,format=raw,cache=writethrough,file=flash1.img \
	-drive if=none,file=image.qcow2,format=qcow2,id=hd0 \
	-drive if=none,file=$BASEDIR/Kylin-Server-V10-SP3-2403-Release-20240426-arm64.iso,format=raw,id=hd1 \
	-device virtio-scsi-pci,id=scsi0 \
	-device scsi-hd,bus=scsi0.0,drive=hd0,bootindex=0 \
	-device scsi-hd,bus=scsi0.0,drive=hd1,bootindex=1 \
	-nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,hostfwd=tcp::5555-:5555 \
	-device VGA \
	-display gtk,gl=off \
	-device qemu-xhci \
	-device usb-tablet \
	-device usb-mouse \
	-device usb-kbd
