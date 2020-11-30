## Backup KVM instances using rsync tool 

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
ssh-copy-id root@IP_Address 
```
