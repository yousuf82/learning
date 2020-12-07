# This guide will help you to create sosrport for RHOPS Servers

list undercloud servers
```
source stackrc
openstack server list 
```
from director access to ctrl server 
```
ssh heat-admin@CTRL-IP
sudo -i
sosreport --case-id=555555  
````
change user owner
```
chown heat-admin.heat-admin /var/tmps/sosrport.tgz
```
exit form root user to heat-admin user
```
exit                                    
```
send the file to director server using scp tool
```
scp /var/tmp/sosrport.tgz stack@DIRECTPR_IP:/home/stack/
```
