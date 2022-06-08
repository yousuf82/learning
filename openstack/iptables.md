
# enable port in iptables (openstack)

create iptables.yml file
```
---
- hosts: all
  become: yes
  tasks:
  - name: Enable port zabbix port 10050 in iptables
    iptables:
      chain: INPUT
      protocol: tcp
      destination_port: 10050
      jump: ACCEPT
      comment: Accept zabbix connections.
  - name: reload iptables
    service:
      name: iptables
      state: reloaded
```
run the ansible file using 
```
source stackrc
ansible-playbook -i /bin/tripleo-ansible-inventory iptables.yml
```
