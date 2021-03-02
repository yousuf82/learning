# How to check mariadb cluster

stop mariadb on both node
```
systemctl stop mariadb
```
check both node which one has big seqno on cat /data/mysqldb/grastate.dat
```
[root@jbossdb-01 ~]#  cat /data/mysqldb/grastate.dat
# GALERA saved state
version: 2.1
uuid:    5cbbc827-69ac-11ea-88c8-c204b5369650
seqno:   65588781
cert_index:
[root@jbossdb-02 ~]# cat /data/mysqldb/grastate.dat
# GALERA saved state
version: 2.1
uuid:    5cbbc827-69ac-11ea-88c8-c204b5369650
seqno:   61284394
cert_index:
```
from above you can see node01 has big seqno

recover database incase any problem 
```
[root@jbossdb-01 ~]# mysqld --wsrep-recover -u root
```
start the maridb on node 01 
```
galera_new_cluster
```
then start on node02
```
systemctl start mariadb
```
