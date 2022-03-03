# Install and deploy Zabbix 6.0 container on RHEL 8

Update the RHEL or OL Server 
```
yum update -y
```

Install utilities :
```
yum install -y wget telnet vim bzip2 net-tools
```
set the hostname
```
hostnamectl set-hostname vzabbixserver.example.org
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
enable docker-compose
```
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
```
```
chmod +x /usr/local/bin/docker-compose
```
```
docker-compose --version
```
clone git repo 
```
git clone https://github.com/zabbix/zabbix-docker.git
```

deploy zabbix 6.0 
```
cd zabbix-docker
docker-compose -f docker-compose_v3_ol_mysql_latest.yaml --profile=all up -d
```

