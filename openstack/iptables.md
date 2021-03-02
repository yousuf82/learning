
# create ansible file 


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
      comment: Accept new 443 connections.
  - name: reload iptables
    service:
      name: iptables
      state: reloaded
