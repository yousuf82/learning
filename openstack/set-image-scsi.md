## configure scsi bus to openstack image 
```
IMAGE_ID=""
openstack image set --property os_type='linux' $IMAGE_ID
openstack image set --property hw_scsi_model='virtio-scsi' $IMAGE_ID
openstack image set --property hw_disk_bus='scsi' $IMAGE_ID
