Chapter-06 Managing Storage in Red Hat OpenStack Platform

```
podman exec -ti ceph-mgr-controller0 ceph osd lspools
podman exec -ti ceph-mgr-controller0 ceph auth list 
podman exec -ti ceph-mgr-controller0 ceph auth get client.admin
podman exec -ti ceph-mgr-controller0 ceph auth print-key client.admin 
podman exec -ti ceph-mgr-controller0 ceph auth print-key client.admin 
systemctl list-units -t service ceph\*
podman exec -ti ceph-mgr-controller0 ceph -s
podman exec -it ceph-mon-controller0 ceph osd lspools
ceph-mon-controller0 ceph auth list

```

``
openstack image list
+--------------------------------------+-----------------+--------+
| ID                                   | Name            | Status |
+--------------------------------------+-----------------+--------+
| a98ec780-6e05-42b0-b094-290e11a6b391 | finance-image   | active |
podman exec -it ceph-mon-controller0 rados -p images ls | grep  a98ec780-6e05-42b0-b094-290e11a6b391
rbd_id.a98ec780-6e05-42b0-b094-290e11a6b391
```

```
openstack volume list
+-------------+-----------------+-----------+------+-------------+
| ID          | Name            | Status    | Size | Attached to |
+-------------+-----------------+-----------+------+-------------+
| 92ef...4f4f | finance-volume1 | available |    1 |             |
```
```
sh root@controller0  podman exec -it ceph-mon-controller0 rados -p volumes ls
rbd_id.volume-92ef6080-60ec-4017-b5ca-5e44485f4f4f
```

```
ssh root@controller0  "podman exec -it cinder_api grep -Ei 'rbd|ceph' /etc/cinder/cinder.conf" | grep -v ^#
podman exec -it glance_api grep -Ei 'rbd|ceph'  /etc/glance/glance-api.conf | grep -v ^#
```

```
ssh heat-admin@controller0 
sudo -i
cd /var/lib/config-data/puppet-generated/swift/etc/swift

swift-ring-builder object.builder
swift-ring-builder account.builder
swift-ring-builder container.builder
```
```
wift-ring-builder object.builder add z1-172.24.4.1:6000/d2 100
swift-ring-builder container.builder add z1-172.24.4.1:6001/d2 100
swift-ring-builder account.builder add z1-172.24.4.1:6002/d2 100
```
```
swift-ring-builder object.builder set_replicas 2
swift-ring-builder container.builder set_replicas 2
swift-ring-builder account.builder set_replicas 2
```
```
swift-ring-builder object.builder
swift-ring-builder account.builder
swift-ring-builder container.builder
```
```
ssh director
curl http://materials.example.com/storage-swiftrings/swift_ring_rebalance.yaml -o /home/stack/swift_ring_rebalance.yaml
```

```
ansible-playbook  -i /usr/bin/tripleo-ansible-inventory  /home/stack/swift_ring_rebalance.yaml
```

```
ssh heat-admin@controller0 
sudo -i
podman restart swift_proxy swift_account_server  swift_container_server swift_object_server
cd /var/lib/config-data/puppet-generated/swift/etc/swift
swift-ring-builder object.builder
swift-ring-builder account.builder
swift-ring-builder container.builder
```

```
openstack container create finance-container1
openstack object create finance-container1 finance-object1
```

```
ssh heat-admin@controller0 find /srv/node -iname *.data
cat finance-object1
ssh heat-admin@controller0  'find /srv/node -iname *.data -exec cat {} \;
```

```
openstack object create  finance-container1 finance-object2
```

```
ssh heat-admin@controller0 find /srv/node -iname *.data
```



