# Deploy and install zabbix 5.0 LTS on CentOS 7
Install utilities :
```
yum install -y wget telnet vim bzip2 net-tools yum-utils
```
Update system

```
yum update -y
```
disabel seliunx service
```
vi /etc/sysconfig/selinux
......
SELINUX=disabled
.....
```
Save & exit the file.

reboot the system after update
```
reboot
```
Enable Zabbix  Repository

Zabbix package is not available in the default yum repository, so we will enable zabbix repository using below command :

```
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm

```

Note the zabbix 5 required php 7 which part of the CentOS Extras repository
```
yum install centos-release-scl -y
```

Install Zabbix Server, Database, Web Server and PHP packages
Use the below command to install rpm package of Zabbix server, Database Sever (MariaDB) , Web Server ( http) and PHP.
```
yum install zabbix-server-mysql zabbix-agent zabbix-web-mysql-scl zabbix-apache-conf-scl mysql mariadb-server httpd  -y
```

Configure Zabbix Database.

Start the Database (MariaDB) service
```
systemctl start mariadb
```
enable MariaDB service to be start on boot
```
systemctl enable mariadb
```
Use ‘mysql_secure_installation‘ command to set the root password of mariadb database and configure other parameters like ‘Remove anonymous users‘, ‘Disallow root login remotely‘ and ‘Remove test database and access to it‘
```
mysql_secure_installation
```
access to mysql
```
mysql -u root -p
```
Now create the Zabbix Database (zabbix) and database user (zabbix) and grant all privileges to the user on the Zabbix database.
```
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@'localhost' identified by 'zabbixpass';
FLUSH PRIVILEGES;
exit;
```
Test mariadb connection and access
```
[root@zabbix-tst yum.repos.d]#  mysql -u zabbix -pzabbixpass -D zabbix
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 17
Server version: 5.5.65-MariaDB MariaDB Server
 
Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
 
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
 
MariaDB [zabbix]>
```
Now import the database Schema using below commands:
```
[root@zabbix-tst yum.repos.d]# cd /usr/share/doc/zabbix-server-mysql-5.0.2/
[root@zabbix-tst zabbix-server-mysql-4.4.9]# gunzip create.sql.gz
[root@zabbix-tst zabbix-server-mysql-4.4.9]# mysql -u zabbix -p zabbix < create.sql
Enter password:
[root@zabbix-tst zabbix-server-mysql-4.4.9]#
```
Edit Zabbix Server Configuration file

Edit the Zabbix Server’s config file (/etc/zabbix/zabbix_server.conf) and specify the database name for zabbix , database user name & its password.
```
[root@zabbix ~]# vi /etc/zabbix/zabbix_server.conf
...................................
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=XXXXXXX
...................................
```
Save & exit the file.


Configure PHP Setting

Set the below parameters in the PHP config file (/etc/php.ini )
```
[root@zabbix ~]# vi /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
................................
date.timezone = Asia/Muscat
...............................
```

Start the Zabbix and Web Server Service and make sure it is enable across the reboot.
```
[root@zabbix ~]# systemctl start zabbix-server zabbix-agent httpd rh-php72-php-fpm
[root@zabbix ~]# systemctl enable zabbix-server zabbix-agent httpd rh-php72-php-fpm
```
Browse the Zabbix Web interface using below URL
http://xxx.xxx.xxx.xxx/zabbix/

Replace the IP address or hostname as per your setup.

![image2020-7-14_14-12-45](https://user-images.githubusercontent.com/72554657/100981124-c64c8180-355f-11eb-93c7-87fc0910b2c3.png)


Click on ‘Next step’

On this Step Zabbix Pre-requisites are checked and verified
![image2020-6-3_11-16-55](https://user-images.githubusercontent.com/72554657/100981421-3955f800-3560-11eb-96bb-9a6b34abfadd.png)


Click on ‘Next step’

Specify the Zabbix Database name, database user and its password.

Zabbix-installation-DB-connection

![image2020-7-14_14-14-35](https://user-images.githubusercontent.com/72554657/100981500-55f23000-3560-11eb-8782-5a865e22c2c8.png)

Click on ‘Next step’ to continue.

Pre-installation summary of Zabbix Servers, click on ‘Next step’ to continue.
![image2020-6-3_11-24-2](https://user-images.githubusercontent.com/72554657/100981573-6acec380-3560-11eb-9c58-0b99cdc88d60.png)
![image2020-6-3_11-24-23](https://user-images.githubusercontent.com/72554657/100981639-7d48fd00-3560-11eb-8699-2c892283855e.png)


As we can see that Zabbix installation is completed successfully
![image2020-6-3_11-25-3](https://user-images.githubusercontent.com/72554657/100981691-8df97300-3560-11eb-9606-56579b4946f1.png)


When we click on ‘finish’ , it will re-direct us to the Zabbix web interface Console.

Use user name as ‘Admin‘ and password ‘zabbix‘

![image2020-7-14_14-40-42](https://user-images.githubusercontent.com/72554657/100981761-a9647e00-3560-11eb-8aa5-16d1ee41f03a.png)

