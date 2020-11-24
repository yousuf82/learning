# This repository is for openstack learning


how to create port with fix ip on openstack 

```console
$ openstack port create --network cma-stg-ext-net --mac-address `fa:16:3e:f1:b1:57` \
--fixed-ip ip-address='10.7.145.62' subport-trunk-cma-port
```
