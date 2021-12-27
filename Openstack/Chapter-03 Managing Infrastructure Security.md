
End-to-end Secure Services
```
yum install  python3-ipaclient python3-ipalib krb5-devel
```
```
ssh controller0
sudo aide -i
sudo \
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
cat /etc/aide.conf
aide --check
cat /var/log/aide/aide.log
sudo vim /root/aide_mon.sh
if ! grep "Looks okay" /var/log/aide/aide.log &>/dev/null
then
	cat /var/log/aide/aide.log | /usr/bin/mail -s "AIDE Alert" heat-admin@controller0
fi 

sudo vim /etc/cron.d/aide
```

AIDE Checks and alert
```
*/2 * * * * root /sbin/aide --check & /root/aide_mon.sh

sudo useradd user01

sudo journalctl -f -u sendmail --since today
```
check 
```
mail
aide --update
mv /var/lib/aide/aide.db.gz /var/lib/aide/aide.db.old.gz
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
aide --check
cat /var/log/aide/aide.log
```