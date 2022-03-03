# Install and deploy Zabbix 6.0 container on RHEL 8

Update the RHEL or OL Server 
```
yum update -y
```
set the time zone
```
timedatectl set-timezone "Asia/Muscat"
```
set the NTP Server 
```
vi /etc/chrony.conf
```
restart the chronyd service
```
systemctl restart chronyd
```

vi /etc/sysconfig/selinux
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
systemctl enable docker
systemctl start docker
yum install git -y

```
