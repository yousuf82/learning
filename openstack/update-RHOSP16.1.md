## Keeping Red Hat OpenStack Platform Updated
### RED HAT OPENSTACK PLATFORM 16.1
### Performing minor updates of Red Hat OpenStack Platform

This guide provides an upgrade path through the following versions:

| Old OpenStack Version           | New OpenStack Version             | 
| ------------------------------- | --------------------------------- |
| Red Hat OpenStack Platform 16.1 | Red Hat OpenStack Platform 16.1.z | 

High level workflow
The following table provides an outline of the steps required for the upgrade process:

| Step  |	Description |
| ------ | ---------------| 
| Updating the undercloud | Update the undercloud to the latest OpenStack Platform 16.1.z version. | 
| Updating the overcloud |Update the overcloud to the latest OpenStack Platform 16.1.z version.|
| Updating the Ceph Storage nodes | Upgrade all Ceph Storage services.|
| Finalize the upgrade | Run the convergence command to refresh your overcloud stack.|

### Preparing for a minor update
```
$ source ~/stackrc
```
Create a static inventory file of your overcloud:
```
tripleo-ansible-inventory --ansible_ssh_user heat-admin --static-yaml-inventory ~/inventory.yaml
```
Create a playbook that contains a task to lock the operating system version to Red Hat Enterprise Linux 8.2 on all nodes:
```
 cat > ~/set_release.yaml <<'EOF'
- hosts: all
  gather_facts: false
  tasks:
    - name: set release to 8.2
      command: subscription-manager release --set=8.2
      become: true
EOF
```
Run the set_release.yaml playbook:
```
ansible-playbook -i ~/inventory.yaml -f 25 ~/set_release.yaml 
```