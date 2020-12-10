# This Guide to convert images using qemu-img tools

## The qemu-img convert command can do conversion between multiple formats, including qcow2, qed, raw, vdi, vhd, and vmdk.
qemu-img format strings
| Image format | Argument to qemu-img|
| --------------|---------------- |
| QCOW2 (KVM, Xen)| qcow2 |
|QED (KVM)| qed|
| raw|rwa|
|VDI (VirtualBox)| vdi|
|HD (Hyper-V)|vpc|
|VMDK (VMware)|vmdk|

This example will convert a raw image file named image.img to a qcow2 image file.
```
$ qemu-img convert -f raw -O qcow2 image.img image.qcow2
```
Run the following command to convert a vmdk image file to a raw image file.
```
$ qemu-img convert -f vmdk -O raw image.vmdk image.img
```
Run the following command to convert a vmdk image file to a qcow2 image file.
```
$ qemu-img convert -f vmdk -O qcow2 image.vmdk image.qcow2
```
