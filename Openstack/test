If the Galera cluster does not restore as part of the restoration procedure, you must restore Galera manually.
Note
In this procedure, you must perform some steps on one Controller node. Ensure that you perform these steps on the same Controller node as you go through the procedure.
Procedure
1.	On os1-prd-ctrl08, retrieve the Galera cluster virtual IP:

```
$ sudo hiera -c /etc/puppet/hiera.yaml mysql_vip
```

2.	Disable the database connections through the virtual IP on all Controller nodes:
$ sudo iptables -I INPUT  -p tcp --destination-port 3306 -d $MYSQL_VIP  -j DROP
3.	On Controller-0, retrieve the MySQL root password:
$ sudo hiera -c /etc/puppet/hiera.yaml mysql::server::root_password
4.	On os1-prd-ctrl08 , set the Galera resource to unmanaged mode:
$ sudo pcs resource unmanage galera-bundle
5.	Stop the MySQL containers on all Controller nodes:
$ sudo docker container stop $(sudo docker container ls --all --format “{{.Names}}” --filter=name=galera-bundle)
6.	Move the current directory on all Controller nodes:
$ sudo mv /var/lib/mysql /var/lib/mysql-save
7.	Create the new directory /var/lib/mysql on all Controller nodes:
8.	$ sudo mkdir /var/lib/mysql
9.	$ sudo chown 42434:42434 /var/lib/mysql
10.	$ sudo chcon -t container_file_t /var/lib/mysql
11.	$ sudo chmod 0755 /var/lib/mysql
12.	$ sudo chcon -r object_r /var/lib/mysql
$ sudo chcon -u system_u /var/lib/mysql
13.	Start the MySQL containers on all Controller nodes:
$ sudo docker container start $(sudo docker container ls --all --format "{{ .Names }}" --filter=name=galera-bundle)
14.	Create the MySQL database on all Controller nodes:
15.	$ sudo docker exec -i $(sudo docker container ls --all --format "{{ .Names }}" \
      --filter=name=galera-bundle) bash -c "mysql_install_db --datadir=/var/lib/mysql --user=mysql"
16.	Start the database on all Controller nodes:
17.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}" \
      --filter=name=galera-bundle) bash -c "mysqld_safe --skip-networking --wsrep-on=OFF" &
18.	Move the .my.cnf Galera configuration file on all Controller nodes:
19.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}" \
      --filter=name=galera-bundle) bash -c "mv /root/.my.cnf /root/.my.cnf.bck"
20.	Reset the Galera root password on all Controller nodes:
21.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}"  \
      --filter=name=galera-bundle) bash -c "mysql -uroot -e'use mysql;update user set password=PASSWORD(\"$ROOTPASSWORD\")where User=\"root\";flush privileges;'"
22.	Restore the .my.cnf Galera configuration file inside the Galera container on all Controller nodes:
23.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}"   \
      --filter=name=galera-bundle) bash -c "mv /root/.my.cnf.bck /root/.my.cnf"
24.	On Controller-0, copy the backup database files to /var/lib/MySQL:
25.	$ sudo cp $BACKUP_FILE /var/lib/mysql
$ sudo cp $BACKUP_GRANT_FILE /var/lib/mysql
Note
The path to these files is /home/heat-admin/.
26.	On Controller-0, restore the MySQL database:
27.	$ sudo docker exec $(docker container ls --all --format "{{ .Names }}"    \
28.	--filter=name=galera-bundle) bash -c "mysql -u root -p$ROOT_PASSWORD < \"/var/lib/mysql/$BACKUP_FILE \"  "
29.	
30.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}"    \
--filter=name=galera-bundle) bash -c "mysql -u root -p$ROOT_PASSWORD < \"/var/lib/mysql/$BACKUP_GRANT_FILE \"  "
31.	Shut down the databases on all Controller nodes:
32.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}"    \
      --filter=name=galera-bundle) bash -c "mysqladmin shutdown"
33.	On Controller-0, start the bootstrap node:
34.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}"  --filter=name=galera-bundle) \
35.	        /usr/bin/mysqld_safe --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock --datadir=/var/lib/mysql \
36.	        --log-error=/var/log/mysql_cluster.log  --user=mysql --open-files-limit=16384 \
        --wsrep-cluster-address=gcomm:// &
37.	Verification: On Controller-0, check the status of the cluster:
38.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}" \
         --filter=name=galera-bundle) bash -c "clustercheck"
Ensure that the following message is displayed: “Galera cluster node is synced”, otherwise you must recreate the node.
39.	On Controller-0, retrieve the cluster address from the configuration:
40.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}" \
--filter=name=galera-bundle) bash -c "grep wsrep_cluster_address /etc/my.cnf.d/galera.cnf" | awk '{print $3}'
41.	On each of the remaining Controller nodes, start the database and validate the cluster:
i.	Start the database:
ii.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}" \
iii.	      --filter=name=galera-bundle) /usr/bin/mysqld_safe --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock \
iv.	      --datadir=/var/lib/mysql --log-error=/var/log/mysql_cluster.log  --user=mysql --open-files-limit=16384 \
      --wsrep-cluster-address=$CLUSTER_ADDRESS &
v.	Check the status of the MYSQL cluster:
vi.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}" \
         --filter=name=galera-bundle) bash -c "clustercheck"
Ensure that the following message is displayed: “Galera cluster node is synced”, otherwise you must recreate the node.
42.	Stop the MySQL container on all Controller nodes:
43.	$ sudo docker exec $(sudo docker container ls --all --format "{{ .Names }}" --filter=name=galera-bundle) \
        /usr/bin/mysqladmin -u root shutdown
44.	On all Controller nodes, remove the following firewall rule to allow database connections through the virtual IP address:
$ sudo iptables -D  INPUT  -p tcp --destination-port 3306 -d $MYSQL_VIP  -j DROP
45.	Restart the MySQL container on all Controller nodes:
$ sudo docker container restart $(sudo docker container ls --all --format  "{{ .Names }}" --filter=name=galera-bundle)
46.	Restart the clustercheck container on all Controller nodes:
$ sudo docker container restart $(sudo docker container ls --all --format  "{{ .Names }}" --filter=name=clustercheck)
47.	On Controller-0, set the Galera resource to managed mode:
$ sudo pcs resource manage galera-bundle

