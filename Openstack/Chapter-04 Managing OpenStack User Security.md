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

