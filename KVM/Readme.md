### This repo for KVM administration

KVM Backup process

list of your machines:
***
virsh list –all
***
The next step is recommended, but not mandatory – you should turn off the VM you want to make a backup of. The command is as follows:
***
virsh shutdown Ubuntu4
***
To check if the shutdown operation was performed correctly, you can request a list of your VMs once again, via the following command:
***
 virsh list –all
 ***
 The next step is to backup the virtual machine’s data into the XML file using the following command:
 ***
  virsh dumpxml Ubuntu4 > /Mybackup/Ubuntu4.xml
 ***
 Another important part of creating a KVM backup is about copying the disk file (.qcow2 format). The default location of this file for an existing VM is at /var/lib/libvirt/images/. You can also use the following command to locate the disk file in question:
 ***
 virsh domblklist Ubuntu4
 ***
 Of course, you’ll have to copy the file in question to the backup location, as well, using the cp or scp commands:
 ***
 cp /var/lib/libvirt/images/Ubuntu4.qcow2 /Mybackup/Ubuntu4.qcow2
 ***
 
