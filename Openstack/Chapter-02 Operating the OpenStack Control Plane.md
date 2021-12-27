Chapter 2: Operating the OpenStack Control Plane
```
podman exec -t galera-bundle-podman-0 mysql -u root -e "show databases;"
grep ^password  /var/lib/config-data/puppet-generated/mysql/root/.my.cnf

pcs resource disable openstack-manila-share
pcs resource enable openstack-manila-share
pcs resource config openstack-manila-share
```
rabbitmq
```
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl report
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl list_users
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl list_exchanges
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl list_queues
podman container exec rabbitmq-bundle-podman-0 rabbitmqctl  list_consumers


podman exec -t rabbitmq-bundle-podman-0 rabbitmqctl  add_user tracer redhat
podman exec -t rabbitmq-bundle-podman-0 rabbitmqctl set_permissions tracer ".*" ".*" ".*"
podman exec -t rabbitmq-bundle-podman-0 rabbitmqctl trace_on
ss -tnlp | grep :5672
~/rmq_trace.py -u tracer -p redhat -t 172.24.1.1 > /tmp/rabbit.trace
 openstack server create....
podman exec -t rabbitmq-bundle-podman-0 rabbitmqctl trace_off

cat /tmp/rabbit.trace | '<string>' | jq
```


```
ansible-playbook -v -i ~/nfs-inventory.ini \
--extra="ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
--become --become-user root --tags bar_setup_nfs_server ~/bar_nfs_setup.yaml

tripleo-ansible-inventory \
--ansible_ssh_user heat-admin \
--static-yaml-inventory /home/stack/tripleo-inventory.yaml

ansible-playbook -v -i ~/tripleo-inventory.yaml \
--extra="ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
--become --become-user root --tags bar_setup_rear \
~/bar_rear_setup-undercloud.yaml

ansible-playbook -v -i ~/tripleo-inventory.yaml \
-e tripleo_backup_and_restore_exclude_paths_controller_non_bootrapnode=false \
--extra="ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
--become --become-user root --tags bar_setup_rear \
~/bar_rear_setup-controller.yaml


ansible-playbook -v -i ~/tripleo-inventory.yaml \
--extra="ansible_ssh_common_args="-o StrictHostKeyChecking=no'" \
--become --become-user root --tags bar_create_recover_image \
~/bar_rear_create_restore_images-undercloud.yaml

ssh utility
sudo watch "tree /ctl_plane_backups && du -sk /ctl_plane_backups"
```