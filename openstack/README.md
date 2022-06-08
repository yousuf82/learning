# This repository is for openstack learning


how to create port with fix ip on openstack 

Create the parent trunk port
```sh
$ openstack port create --network public parent-trunk-port
```
Create a trunk
```
$ openstack network trunk create --parent-port parent-trunk-port parent-trunk
```
Create a subnet port with fix ip

```
# for OSP 13
$ openstack port create --network cma-stg-ext-net --mac-address `fa:16:3e:f1:b1:57` \
--fixed-ip ip-address='10.7.145.62' subport-trunk-cma-port
```
for OSP 16
```
openstack port create --network gw-migraton  --disable-port-security --no-security-group \
--mac-address fa:16:3e:1b:07:90 gw-migraton-FG_Trunk_Subport 

```
Associate the subnet port with the trunk 
```
# for OSP 13
openstack network trunk set --subport port=subport-trunk-port,segmentation-type=vlan,segmentation-id=1477 \
parent-trunk
```
```
#for OSP 16
openstack network trunk set --subport port=gw-migraton-FG_Trunk_Subport,segmentation-type=vlan,segmentation-id=3000 FG-Trunk
```
