#!/usr/bin/env bash


qemu-img convert -f vdi -O qcow2 source.vdi target.qcow2

qemu-img convert -f vdi -O raw source.vdi target.raw

qemu-system-x86_64 -m 1024 -hda target.qcow2 -cdrom /path/to/your/os.iso -boot d
qemu-system-x86_64 -m 1024 -hda target.qcow2 -cdrom /path/to/your/os.iso -boot d
