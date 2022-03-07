Chapter 1: Navigating the Red Hat OpenStack Platform Architecture (undercloud)

openstack commands
```
openstack endpoint list
openstack service list
openstack server list
cat  undercloud-passwords.conf
cat undercloud.conf | egrep -v "(^#.*|^$)"
openstack tripleo container image prepare default --local-push-destination  --output-env-file local_registry_images.yaml
openstack subnet show ctlplane-subnet
openstack image list
openstack baremetal node list
openstack stack list
ipmitool -I lanplus -U admin -P password  -H 172.25.249.112 power status
openstack baremetal node power on controller0
openstack baremetal node power off controller0
```

list container and filter option
```
podman ps    --filter status=running --format="table {{.ID}} {{.Names}} {{.Status}}"
podman ps -a --format="table {{.Names}} {{.Status}}" | grep heat
podman stats cinder_api
podman logs --since 3h  --tail 4 cinder_api
podman images --format="{{.Repository}}"
```
show as json output
```
podman images
podman inspect cinder_api
podman inspect neutron_api | jq .[0].HostConfig.Binds
podman inspect nova_scheduler  --format "{{json .HostConfig.Binds}}" | jq .
```

run command within container
```
podman exec -it keystone /bin/bash
podman exec -u root keystone crudini --get /etc/keystone/keystone.conf DEFAULT debug
crudini --get  /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone.conf DEFAULT debug
crudini --set /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone.conf DEFAULT debug True
podman restart keystone
podman exec -u root keystone crudini --get /etc/keystone/keystone.conf DEFAULT debug 
```
Ceph 
```
podman exec ceph-mon-controller ceph osd ls
podman exec ceph-mon-controller0 ceph osd lspools
podman exec ceph-mon-controller ceph -s
podman exec ceph-mon-controller ceph df
podman ps --format '{{ .Names}}' | grep ceph
```

manage containers using systemd
```
systemctl list-timers | grep tripleo
systemctl list-units | grep tripleo
cat /etc/systemd/system/tripleo_cinder_api.service
systemctl status tripleo_cinder_api
ls /etc/systemd/system/tripleo_*.service
```

Describing the Overcloud
```
grep '^- name:' ~/templates/roles_data.yaml
openstack endpoint list 
ip -br a
ip -br a s vlan134
netstat -tupln | grep 10.14.132.125
```


