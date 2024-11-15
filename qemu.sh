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

# dd if=/dev/zero of=flash0.img bs=1m count=64
# dd if=QEMU_EFI.fd of=flash0.img conv=notrunc
# dd if=/dev/zero of=flash1.img bs=1m count=64



qemu-system-aarch64 \
	-M virt \
	-m 16384 \
	-cpu cortex-a72 \
	-smp 32 \
	-drive if=pflash,media=disk,format=raw,cache=writethrough,file=flash0.img \
	-drive if=pflash,media=disk,format=raw,cache=writethrough,file=flash1.img \
	-drive if=none,file=arch-aarch64.qcow2,format=qcow2,id=hd0 \
	-device virtio-scsi-pci,id=scsi0 \
	-device scsi-hd,bus=scsi0.0,drive=hd0,bootindex=1 \
	-nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,hostfwd=tcp::5555-:5555 \
	-device virtio-gpu-gl-pci,xres=1280,yres=1024 \
	-display sdl,gl=on \
	-device qemu-xhci,id=xhci \
	-device usb-host,bus=xhci.0,hostdevice=/dev/bus/usb/003/009 \
	-device usb-host,bus=xhci.0,hostdevice=/dev/bus/usb/003/010
