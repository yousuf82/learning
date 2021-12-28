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