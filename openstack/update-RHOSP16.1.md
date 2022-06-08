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
Updating Red Hat Openstack Platform and Ansible repositories

```
cat rhosp16-subscription.yml
---
- name: Register all OSP servers to satellite
  hosts: all
  become: yes
  vars:
    repos:
      - rhel-8-for-x86_64-baseos-tus-rpms
      - rhel-8-for-x86_64-appstream-tus-rpms
      - rhel-8-for-x86_64-highavailability-tus-rpms
      - ansible-2.9-for-rhel-8-x86_64-rpms
      - advanced-virt-for-rhel-8-x86_64-rpms
      - openstack-16.1-for-rhel-8-x86_64-rpms
      - rhceph-4-tools-for-rhel-8-x86_64-rpms
      - fast-datapath-for-rhel-8-x86_64-rpms
  tasks:
    - name: install katello-ca package with rpm
      yum:
        name: "http://$SERVER/pub/katello-ca-consumer-latest.noarch.rpm"
        state: present
    - name: clean redhat subscription
      command: subscription-manager clean
    - name: Register system
      redhat_subscription:
        activationkey: osp16_non-prod
        org_id: "Default_Organization"
        force_register: yes
    - name: Disable all repos
      rhsm_repository:
        name: "*"
        state: disabled
    - name: Enable Compute node repos
      rhsm_repository:
        name: "{{ repos }}"
        state: enabled
```
```
 ansible-playbook -i inventory.yaml rhosp16-subscription.yml
```
Setting the container-tools and virt module versions

Create a playbook that contains a task to set the container-tools module to version 2.0 on all nodes:
```
 cat > ~/container-tools.yaml <<'EOF'
- hosts: all
  gather_facts: false
  tasks:
    - name: disable default dnf module for container-tools
      command: dnf module disable -y container-tools:rhel8
      become: true
    - name: set dnf module for container-tools:2.0
      command: dnf module enable -y container-tools:2.0
      become: true

- hosts: undercloud,Compute,Controller
  gather_facts: false
  tasks:
    - name: disable default dnf module for virt
      command: dnf module disable -y virt:rhel
      become: true
    - name: disable 8.1 dnf module for virt
      command: dnf module disable -y virt:8.1
      become: true
    - name: set dnf module for virt:8.2
      command: dnf module enable -y virt:8.2
      become: true
EOF
```
run the command :
```
ansible-playbook -i inventory.yaml -f 25 container-tools.yaml
````
Edit the container preparation file. The default name for this file is usually containers-prepare-parameter.yaml.
Check the tag parameter is set to 16.1 for each rule set:
```
parameter_defaults:
  ContainerImagePrepare:
  - push_destination: true
    set:
      …​
      tag: '16.1'
    tag_from_label: '{version}-{release}'
```

Disabling fencing in the overcloud

```
ssh heat-admin@CONTROLLER_IP "sudo pcs property set stonith-enabled=false"
```

Updating the Undercloud

Log in to the director as the stack user.
Run dnf to upgrade the director main packages:
```
sudo dnf update -y python3-tripleoclient* tripleo-ansible ansible
```


 Updating the overcloud images
 
 ```
 openstack undercloud upgrade
 ```
 Wait until the undercloud upgrade process completes.
Reboot the undercloud to update the operating system’s kernel and other system packages:
```
sudo reboot
```
Updating the overcloud images

```
source ~/stackrc
rm -rf ~/images/*
cd ~/images
for i in /usr/share/rhosp-director-images/overcloud-full-latest-16.1.tar /usr/share/rhosp-director-images/ironic-python-agent-latest-16.1.tar; do tar -xvf $i; done
cd ~
openstack overcloud image upload --update-existing --image-path /home/stack/images/
openstack overcloud node configure $(openstack baremetal node list -c UUID -f value)
openstack image list
ls -l /var/lib/ironic/httpboot
```
Running the overcloud update preparation

```
openstack overcloud update prepare \
    --templates \
    --stack <stack_name> \
    -r <roles_data_file> \
    -n <network_data_file> \
    -e <environment_file> \
    -e <environment_file> \
  ```
  Running the container image preparation
  ```
  openstack overcloud external-update run --stack overcloud --tags container_image_prepare
  ```
Optional: Updating the ovn-controller container on all overcloud servers
```
openstack overcloud external-update run --stack overcloud --tags ovn
```
Updating all Controller nodes
```
openstack overcloud update run --stack <stack_name> --limit Controller --playbook all
```
Updating all Compute nodes

To update specific Compute nodes, list the nodes that you want to update in a batch separated by a comma:
```
openstack overcloud update run --limit <Compute0>,<Compute1>,<Compute2>,<Compute3>
 ```


Updating all HCI Compute nodes

```
openstack overcloud update run --stack overcloud  --limit ComputeHCI --playbook all
```
Run the Ceph Storage update command
```
openstack overcloud external-update run --stack overcloud --tags ceph
```
