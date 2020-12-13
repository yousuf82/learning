# This guide to customize qcow2 images

First, access set LIBGUESTFS_BACKEND to direct
```
export LIBGUESTFS_BACKEND=direct
```
set root password for qcow2 image
```
virt-customize -a rhel8.2.qcow2 --root-password password:testpass
```
Install rpm file in qcow2 image
```
virt-customize -a rhel8.2.qcow2 --run-command 'rpm -ivh http://satellite.example.com/pub/katello-ca-consumer-latest.noarch.rpm'
```
upload file to qcow2 image 
```
virt-customize -a rhel8.2.qcow2 --upload opendaylight.repo:/etc/yum.repos.d/
```
