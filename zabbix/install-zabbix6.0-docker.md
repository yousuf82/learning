# Install and deploy Zabbix 6.0 container on RHEL 8

Install utilities :

```
yum install -y wget telnet vim bzip2 net-tools
```

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
disable SeLinux
```
vi /etc/sysconfig/selinux
```
intall reqired packgets
```
yum install -y yum-utils device-mapper-persistent-data lvm2
```
enable docker repo
```
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
install docker 
```
yum install docker-ce -y
```
enable and start docker service 
```
systemctl enable docker
systemctl start docker
```
install git tool 
```
yum install git -y
```
