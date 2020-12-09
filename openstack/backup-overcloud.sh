#!/bin/sh
# This script create backup for overcloud controller node incloude MariaDB
PASS=`sudo hiera -c /etc/puppet/hiera.yaml mysql::server::root_password`
DATE=`date +%F-%H%M%S`
DIR=`date +%a-%Y%m%d`
mkdir -p /backup/openstackDB-$DIR
CHDIR="/backup/openstackDB-$DIR"
mysql --password=$PASS  -e "select distinct table_schema from information_schema.tables where engine='innodb' and table_schema != 'mysql';" -s -N | xargs mysqldump --password=$PASS --single-transaction --databases |  gzip -c > $CHDIR/openstack_database_$DATE.sql.gz
mysql --password=$PASS -e "SELECT CONCAT('\"SHOW GRANTS FOR ''',user,'''@''',host,''';\"') FROM mysql.user where length(user) > 0"  -s -N | xargs -n1 mysql  --password=$PASS -s -N -e | sed 's/$/;/' > $CHDIR/grants_$DATE.sql
exit
