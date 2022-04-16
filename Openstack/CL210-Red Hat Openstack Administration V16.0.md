# EX210 Red Hat Certified Specialist in Cloud Infrastructure exam
https://www.redhat.com/en/services/training/ex210-red-hat-certified-system-administrator-red-hat-openstack-exam?section=Objectives

## Study points for the exam

To become a Red Hat Certified System Administrator in Red Hat OpenStack, you will validate your ability to perform these tasks:

* Manage the Red Hat OpenStack Platform control plane
  * Manage control plane services
  * Backup and restore control plane
  * Start and stop an overcloud
* Manage infrastructure security
  * Manage end-to-end secure services
  * Manage file-based component security with AIDE
* Manage user security
  * Manage an integrated IdM back-end configuration
  * Manage scoped service access
  * Manage project organization
  * Create a Red Hat OpenStack Platform domain for a client organization
  * Maintain token keys
  * Customize user roles
* Manage application deployment resources
  * Create images and flavors
  * Create and customize images
  * Initialize an instance during deployment
* Manage storage in Red Hat OpenStack Platform
  * Manage a Red Hat OpenStack Platform-dedicated Ceph storage cluster
  * Implement storage choices in Red Hat OpenStack Platform
  * Manage a Ceph storage cluster
  * Configure storage infrastructure
  * Manage Swift storage
* Manage networking
  * Configure Open Virtual Networking (OVN) services
  * Create and manage shared networks
* Manage compute node operations
  * Administer compute nodes
  * Manage compute resource capacity
  * Manage hyperconverged resource capacity
  * Re-balance compute node workloads
* Monitor operations
  * Implement the Service Telemetry Framework
  * Understand the flow of Red Hat OpenStack Platform services and components logging
* Automate cloud application deployment
  * Manage mass-scale application deployment
  * Write heat orchestration templates
  * Deploy applications using Ansible
  * Create a load-balanced application stack
* Troubleshoot operations
   * Diagnose issues
   * Troubleshoot common core issues
   * Trace heat stack events and troubleshoot failures

As with all Red Hat performance-based exams, configurations must persist after reboot without intervention.

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
podman ps --filter status=running --format="table {{.ID}} {{.Names}} {{.Status}}"
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
ip -br a
ip -br a s vlan134
netstat -tupln | grep 10.14.132.125
```

Chapter 2: Operating the OpenStack Control Plane
```
podman exec -t galera-bundle-podman-0 mysql -u root -e "show databases;"
grep ^password  /var/lib/config-data/puppet-generated/mysql/root/.my.cnf

pcs resource disable openstack-manila-share
pcs resource enable openstack-manila-share
pcs resource config openstack-manila-share
```
rabbitmq
```
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl report
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl list_users
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl list_exchanges
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl list_queues
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl  list_consumers


podman exec -t rabbitmq-bundle-podman-0 rabbitmqctl  add_user tracer redhat
podman exec -t rabbitmq-bundle-podman-0 rabbitmqctl set_permissions tracer ".*" ".*" ".*"
podman exec -t rabbitmq-bundle-podman-0 rabbitmqctl trace_on
ss -tnlp | grep :5672
~/rmq_trace.py -u tracer -p redhat -t 172.24.1.1 > /tmp/rabbit.trace
 openstack server create....
podman exec -t rabbitmq-bundle-podman-0 rabbitmqctl trace_off

cat /tmp/rabbit.trace | '<string>' | jq
```


```
ansible-playbook -v -i ~/nfs-inventory.ini \
--extra="ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
--become --become-user root --tags bar_setup_nfs_server ~/bar_nfs_setup.yaml

tripleo-ansible-inventory \
--ansible_ssh_user heat-admin \
--static-yaml-inventory /home/stack/tripleo-inventory.yaml

ansible-playbook -v -i ~/tripleo-inventory.yaml \
--extra="ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
--become --become-user root --tags bar_setup_rear \
~/bar_rear_setup-undercloud.yaml

ansible-playbook -v -i ~/tripleo-inventory.yaml \
-e tripleo_backup_and_restore_exclude_paths_controller_non_bootrapnode=false \
--extra="ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
--become --become-user root --tags bar_setup_rear \
~/bar_rear_setup-controller.yaml


ansible-playbook -v -i ~/tripleo-inventory.yaml \
--extra="ansible_ssh_common_args="-o StrictHostKeyChecking=no'" \
--become --become-user root --tags bar_create_recover_image \
~/bar_rear_create_restore_images-undercloud.yaml

ssh utility
sudo watch "tree /ctl_plane_backups && du -sk /ctl_plane_backups"
```

End-to-end Secure Services
```
yum install  python3-ipaclient python3-ipalib krb5-devel
```
```
ssh controller0
sudo aide -i
sudo \
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
cat /etc/aide.conf
aide --check
cat /var/log/aide/aide.log
sudo vim /root/aide_mon.sh
if ! grep "Looks okay" /var/log/aide/aide.log &>/dev/null
then
	cat /var/log/aide/aide.log | /usr/bin/mail -s "AIDE Alert" heat-admin@controller0
fi 

sudo vim /etc/cron.d/aide
```

AIDE Checks and alert
```
*/2 * * * * root /sbin/aide --check & /root/aide_mon.sh

sudo useradd user01

sudo journalctl -f -u sendmail --since today
```
check 
```
mail
aide --update
mv /var/lib/aide/aide.db.gz /var/lib/aide/aide.db.old.gz
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
aide --check
cat /var/log/aide/aide.log
```
Create IDM User on IPA server
```
ssh utility
sudo -i
kinit admin
Password for admin@LAB.EXAMPLE.NET: RedHat123^
echo redhat | ipa user-add svc-ldap  --first=OpenStack --last=LDAP --password
```
install IDM CA on controller0
```
ssh controller0
sudo -i
scp root@utility:/etc/ipa/ca.crt .
password:
openssl x509 -in ca.crt -out idm_ca.pem -outform PEM
cp idm_ca.pem /etc/pki/ca-trust/source/anchors/
update-ca-trust extract
setsebool -P authlogin_nsswitch_use_ldap=on
```
keystone settings
```
mkdir  /var/lib/config-data/puppet-generated/keystone/etc/keystone/domains/
chown 42425:42425 /var/lib/config-data/puppet-generated/keystone/etc/keystone/domains/
cd  /var/lib/config-data/puppet-generated/keystone/etc/keystone/
crudini --set keystone.conf identity domain_specific_drivers_enabled true
crudini --set keystone.conf identity domain_config_dir /etc/keystone/domains
crudini --set keystone.conf assignment driver sql
```

hourizon settings
```
cd /var/lib/config-data/puppet-generated/horizon/etc/openstack-dashboard/
vim local_settings
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'Default'
```
KEYSTONE
```
cd /var/lib/config-data/puppet-generated/keystone/etc/keystone/domains/
vim keystone.Example.conf
-----------------
[ldap]
url =  ldaps://utility.lab.example.com
user = uid=svc-ldap,cn=users,cn=accounts,dc=lab,dc=example,dc=net
password = redhat
user_tree_dn = cn=users,cn=accounts,dc=lab,dc=example,dc=net
user_objectclass = inetUser
user_id_attribute = uid
user_name_attribute = uid
user_mail_attribute = mail
user_pass_attribute =
user_allow_create = False
user_allow_update = False
user_allow_delete = False
group_objectclass = groupofnames
group_tree_dn = cn=groups,cn=accounts,dc=lab,dc=example,dc=net
group_id_attribute = cn
group_name_attribute = cn
group_allow_create = False
group_allow_update = False
group_allow_delete = False
use_tls = False
query_scope = sub
chase_referrals = false
tls_cacertfile = /etc/pki/ca-trust/source/anchors/idm_ca.pem
[identity]
driver = ldap
--------------------
```
```
chown 42425:42425 keystone.Example.conf
```

in overcloud run

```
source ~/admin-rc
openstack domain create Example
openstack role add --domain Example --user admin  admin
```

in Controller0

```
ssh controller0
sudo -i
systemctl restart tripleo_keystone
systemctl restart tripleo_horizon
```

in overcloud run
```
openstack user list --domain Example -f json
```


in Controller0

```
ssh controller0
sudo -i
crudini --get /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone.conf token provider
fernet 
crudini --get /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone.conf catalog driver
sql 
crudini --get /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone.conf  fernet_tokens key_repository 
/etc/keystone/fernet-keys
crudini --get /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone.conf  fernet_tokens max_active_keys 
5 
ls -l  /var/lib/config-data/puppet-generated/keystone/etc/keystone/fernet-keys/
0 1
cat  /var/lib/config-data/puppet-generated/keystone/etc/keystone/fernet-keys/0; echo 
cat  /var/lib/config-data/puppet-generated/keystone/etc/keystone/fernet-keys/1; echo 
```
```
openstack workflow execution create tripleo.fernet_keys.v1.rotate_fernet_keys '{"container": "overcloud"}'
```

Create Domain 

```
openstack domain create Lab
openstack project create support --domain Lab
openstack project create dev --parent support  --domain Lab
openstack group create developers --domain Lab
openstack role add --group developers --group-domain Lab --project support --project-domain Lab member
openstack role add --group developers --group-domain Lab --project support --project-domain Lab --inherited member
openstack user create developer4 --domain Lab --password redhat
openstack group add user --group-domain Lab --user-domain Lab developers developer4
openstack role assignment list --project support --project-domain Lab --names --effective
openstack role assignment list --project dev --project-domain Lab --names --effective
```


Customizing User Roles

```
source ~/admin-rc
openstack role create troubleshooters
openstack role add --project finance --user developer1 --user-domain Example e4e05ea96439 	439c9fb53fbbf3af8314
source ~/developer1-finance-rc
openstack server show finance-server1
 No admin rights like OS-EXT-SRV-ATTR:host,OS-EXT-SRV-ATTR:hypervisor_hostname 
```
```
ssh controller0
sudo -i
yum install python3-oslo-policy
podman exec -it nova_api oslopolicy-policy-generator --namespace nova > nova_policy.txt
grep os-extended-server-attributes nova_policy.txt > /var/lib/config-data/puppet-generated/nova/etc/nova/policy.json
vi /var/lib/config-data/puppet-generated/nova/etc/nova/policy.json
"os_compute_api:os-extended-server-attributes": "rule:admin_api or role:troubleshooters"
cat  /var/lib/config-data/puppet-generated/nova/etc/nova/policy.json | python -m json.tool
systemctl restart tripleo_nova_api
```

Test
```
openstack server show finance-server1
```

Managing Application Deployment Resources

```
cp -a /usr/share/diskimage-builder/elements  /home/student/
mkdir -p /home/student/elements/rhel/post-install.d
cd /home/student/elements/rhel/post-install.d/
cat <<EOF > 01-enable-services
> #!/bin/bash
> systemctl enable named
> EOF
```

```
cat <<EOF > 02-configure-named
> #!/bin/bash
> 
> # add forwarders
> sed -i 's|\(.*\)\(recursion yes;\)|\1\2\n\1forwarders {172.25.250.254;};|' \
> /etc/named.conf
> 
> # allow queries from the local subnet
> sed -i 's|\(.*allow-query\).*|\1     { localhost; 192.168.1.0/24; };|' \
> /etc/named.conf
> 
> # disable dnssec validation
> sed -i 's|\(.*dnssec-validation\).*|\1 no;|' /etc/named.conf
> EOF
 chmod +x *
```

```
export DIB_LOCAL_IMAGE=/home/student/osp-small.qcow2
export DIB_YUM_REPO_CONF=/etc/yum.repos.d/openstack.repo
export ELEMENTS_PATH=/home/student/elements
export DIB_NO_TMPFS=1
```

```
disk-image-create vm rhel -t qcow2 -p bind,bind-utils  -o finance-rhel-dns.qcow2
```

```
source ~/developer1-finance-rc

openstack server create  --flavor default  --key-name example-keypair --nic net-id=finance-network1 \
--image finance-rhel-dns  --security-group finance-dns  --config-drive true  --wait finance-dns1
```

```
openstack server add floating  ip finance-dns1 172.25.250.110
```


```
ssh cloud-user@172.25.250.110

sudo ss -4nlp | grep named
```



```
wget http://materials.example.com/osp-small.qcow2 -O ~/finance-rhel-db.qcow2
```


```
guestfish -i --network -a ~/finance-rhel-db.qcow2
><fs> command "dnf -y install mariadb mariadb-server"
<fs> command "systemctl enable mariadb"
<fs> command "systemctl is-enabled mariadb"
<fs> selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /
<fs> exit
```
```
source ~/developer1-finance-rc
```

```
openstack image create --disk-format qcow2 --min-disk 10 --min-ram 2048 --file ~/finance-rhel-db.qcow2 finance-rhel-db
```

```
openstack server create --flavor default --key-name example-keypair --nic net-id=finance-network1 \
--security-group finance-db --image finance-rhel-db --config-drive true --wait finance-db1
openstack server add floating ip finance-db1 172.25.250.110
ssh cloud-user@172.25.250.110
rpm -q mariadb-server
systemctl status mariadb
```

```
wget  http://materials.example.com/osp-small.qcow2 -O ~/finance-rhel-mail.qcow2
virt-customize \
 -a ~/finance-rhel-mail.qcow2 \
--run-command 'dnf -y install postfix mailx' \
--run-command 'systemctl enable postfix' \
--run-command 'postconf -e "relayhost = [workstation.lab.example.com]"' \
--run-command 'postconf -e "inet_interfaces = all"' \
--selinux-relabel 
```

```
openstack image create \
--disk-format qcow2 \
--min-disk 10 \
--min-ram 2048 \
--file ~/finance-rhel-mail.qcow2 \
finance-rhel-mail
```
```
openstack server create \
--flavor default \
--key-name example-keypair \
--nic net-id=finance-network1 \
--security-group finance-mail \
--image finance-rhel-mail \
--config-drive true \
--wait finance-mail1
```

```
openstack server add floating ip finance-mail1 172.25.250.107
ssh cloud-user@172.25.250.107
systemctl status postfix
sudo ss -tnlp | grep master
postconf relayhost
mail -s "Test" student@workstation.lab.example.com
Hello World!
.
EOT
```

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

```
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



Configuring Provider Networks
```
ovs-vsctl get open . external-ids:ovn-bridge-mappings
```

