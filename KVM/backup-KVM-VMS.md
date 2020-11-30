# Backup KVM instances using rsync tool 

## configure SSH key trust
In KVM Host:
1. genrate ssh key and copy public key to backup server:
```
$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:FwWsYtA474WmEreIPiQnIG39nq7m90oPPvYXg5cjmb0 root@cekov
The key's randomart image is:
+---[RSA 2048]----+
| o .... |
| + . .. |
| . . + . .. |
|o + o * o . |
|oo + B oS=.. |
|+.+ o o =.B |
|+o . .o. o = |
| o .o*o E |
| .oo=+=+. |
+----[SHA256]-----+
```
2. copy ssh key to backup server 
```
ssh-copy-id root@BACKUP_IP_ADDRESS
```
3. Test access to backup server using ssh 

```
ssh root@BACKUP_IP_ADDRESS
```

## Install rync tool on KVM Host

```
yum install rsync -y
```

## Now use this script to backup all VMs qcow2 images and XML from KVM server to Backup Server 

```
#!/bin/sh
# Backup script to backup KVM VMs qcow2 images and xml files
VMS=`virsh list | grep running | awk '{ print $2 }'`
VMS_PATH="/var/lib/libvirt/"
BACKUP_IP=192.168.10.100
BACKUP_PATH="/backup/"

#Backup XML files for all running VMS 
for i in $VMS; do virsh dumpxml $i > $VMS_PATH/$i.xml; done

# replicate all data include (qcow2 images and XML files) to backup server using rsync tool 

rsync -auvz  --delete $VMS_PATH root@BACKUP_IP:$BACKUP_PATH
```


## save the backup-kvm.sh script and make sure change the mode 
```
chmod +x backup-kvm.sh
```

## run the script and wait some time until files trasfered to backup server
```
./backup-kvm.sh
```
## you can configure script to run daily with crontab 

create crontab job:
```
crontab -e 
```
add below line for example if you want to run at 3.30 AM daily 
```
30 3 * * * /root/backup-kvm.sh
```
save the configration 

list crontab jobs
```
crontab -e 
30 3 * * * /root/backup-kvm.sh
```




