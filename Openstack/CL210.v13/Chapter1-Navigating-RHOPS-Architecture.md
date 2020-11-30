## Chapter 1: Navigating the Red Hat OpenStack Platform Architecture

List the networks and interfaces on the overcloud nodes.

```
[student@workstation ~]$ ssh stack@director
(undercloud) [stack@director ~]$ openstack network list
(undercloud) [stack@director ~]$ ip a | grep -E 'br-ctlplane|eth1'
(undercloud) [stack@director ~]$ openstack compute service list -c Binary -c Host -c Status -c State
+----------------+--------------------------+---------+-------+
| Binary         | Host                     | Status  | State |
+----------------+--------------------------+---------+-------+
| nova-conductor | director.lab.example.com | enabled | up    |
| nova-scheduler | director.lab.example.com | enabled | up    |
| nova-compute   | director.lab.example.com | enabled | up    |
+----------------+--------------------------+---------+-------+
(undercloud) [stack@director ~]$ openstack catalog list -c Name -c Endpoints
+------------------+------------------------------------------+
| Name             | Endpoints                                |
+------------------+------------------------------------------+
| ironic-inspector | regionOne                                |
|                  |   public: https://172.25.249.201:13050   |
|                  | regionOne                                |
|                  |   internal: http://172.25.249.202:5050   |
|                  | regionOne                                |
|                  |   admin: http://172.25.249.202:5050      |
```
List servres:
```
(undercloud) [stack@director ~]$ openstack server list -c Name -c Networks
```
List networks:
```
(undercloud) [stack@director ~]$ openstack network list -c Name -c Subnets
+--------------+--------------------------------------+
| Name         | Subnets                              |
+--------------+--------------------------------------+
| ctlplane     | 6457fb0f-2d9d-43af-93ca-f0c3dc008c82 |
+--------------+--------------------------------------+

```
show subnet details:
```
(undercloud) [stack@director ~]$ openstack subnet show 6457fb0f-2d9d-43af-93ca-f0c3dc008c82
+-------------------+---------------------------------+
| Field             | Value                           |
+-------------------+---------------------------------+
| allocation_pools  | 172.25.249.51-172.25.249.59     |
```
Search for the dhcp_start and dhcp_end parameter IP adresses in the undercloud.conf file
```
(undercloud) [stack@director ~]$ grep '^dhcp_' undercloud.conf
dhcp_start = 172.25.249.51
dhcp_end = 172.25.249.59
```

list docker services :
```
ssh heat-admin@controller0
 docker ps --format="table {{.Names}}\t{{.Status}}"
NAMES                              STATUS
ovn-dbs-bundle-docker-0            Up 7 hours
openstack-manila-share-docker-0    Up 7 hours
openstack-cinder-volume-docker-0   Up 7 hours

 docker stop nova_api
  docker ps -a --format="table {{.Names}}\t{{.Status}}" | grep nova_api
...output omitted...
nova_api                           Exited (0) 2 minutes ago
docker start nova_api
docker ps --format="table {{.Names}}\t{{.Status}}" | grep nova_api
  
  
