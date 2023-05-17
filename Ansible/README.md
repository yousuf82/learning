# Ansible Course RH294

## install ansible
```
yum install ansible -y
```

## verfiy ansbile version

```
ansible --version
```

## Verify the ansible_python_version

```
ansible -m setup localhost | grep ansible_python_version
```


## enable yaml format in vim editor

```
vim .vimrc
```

```
autocmd FileType yaml setlocal ai ts=2 sw=2 et nu cuc
autocmd FileType yaml colo desert
```


## ansible.cfg example
```
[defaults]
inventory = ./inventory
remote_user = someuser
ask_pass = false
[privilege_escalation]
become = true
become_method = sudo
become_user = root
become_ask_pass = false
```

## LAB 1   install ansible package

```
sudo yum install ansible
ansible --version
ansible -m setup localhost | grep ansible_python_version
```

## LAB 2 create inventory file
```
ansible all --list-hosts
ansible ungrouped list-hosts
ansible group1 list-hosts
```
```
inventory file
server[a:d].lab.example.com
[group3:children]
group1
group2
```

## LAB 3 Create ansible.cfg file
```
ansible.cfg
[defaults]
inventory = ./inventory
[privilege_escalation]
become = ture
become_method = sudo
become_user = root
become_ask_pass = false
```

## LAB 4 add Hoc command
```
sudo -l -U devops  # check the permsion for user devops
sudo -l 			# check the permision for current user
ansible servera -m command -a 'id' -u devops # run command id using ansible ad Hoc 
ansible server -m copy -a 'content="Managed by Ansible\n" dest=/etc/motd' -u devops --become
```
## LAB 5 create playbook file 
```
site.yml
---
  - name: install and configure apache
    hosts: web
	tasks:
	  - name: install httpd package
	    yum:
		  name: httpd
		  state: latest
	  - name: copy index file
		copy:
		  src: file/index.html
		  dest: /var/www/html/index.html
	
	  - name: enable httpd service
		service:
		  name: httpd
		  state: started
		  enabled: true
```
```
ansible-playbook site.yml --syntax-check
ansible-playbook site.yml -C
ansible-playbook site.yml
```

## LAB 6  use variables

```
---
  - name: use variables
	hosts: servera.lab.exampl.com
	vars:
		web_pkg: httpd
		firewalld_pkg: firewalld
		firewalld_service: firewalld
		we_service: httpd
		rule: http
	tasks:
	  - name: install {{ web_pkg }}
		yum:
		  name: "{{ web_pkg }}"
		  state: latest
```		  
		  
		  
		  
### us can include variables from file using 
```
	 vars_files:
		- vars/users.yml
```
## inventory variables
	by host
	```
	host_vars/servera.lab.example.com
	```
	by group
	```
	group_vars/webservers
	```
	
## use arrary for variables
```
	users:
	  john:
		first_name: john
		last_name: mark
		home_dir: /users/john
	  mike:
	    first_name: mike
		last_name: tom
		home_dir: /users/mike
```		
## To call array variables
```
	users['john']['home_dir']  # mean /users/john
```

## LAB 7 	Manage secrets

create encrypted file
```
ansible-vault create file 						
```
edit encrypted file
```
ansible-vault edit file  
```
encrypt file already exists
```
ansible-vault encrypt file
```
decrypt the file
```
ansible-vault decrypt file --output file2
```
set new a password key for encrypted file
```
ansible-vault rekey file
```
## to run the playboot with encrypted file
```
ansible-playbook test.yml --ask-vault-pass
ansible-playbook test.yml --vault-password-file pass.txt
```
## to ssh to host with password prompt use this option
```
ssh -o PreferredAuthentications=password
```

## LAB 8 manage facts

custom facts variables save as file.fact
format of file.fact :
```
[packages]
web = httpd
db	= mariadb-server
```

custome facts variables on host save under /etc/ansible/facts.d/

use facts variables on yaml playbook like
``
{{ ansible_facts['fqdn'] }} 
```


## Chapter 10 Modules

yum_repository			# to create and remove repo file
rpm_key				# install and remove rpm key
redhat_subscription		# register systems with rhel subscription
rhsm_repository			# manage rhms repos enable and disable
package_facts			# gethering package information as facts

## LAB Failures condition

```
ignore_errors: yes
changed_when: false
failed_when: web_srv == httpd
```
```
block:
rescue:
always
```
```
firewalld:
  service: http
  state: enabled
  permanent: ture
  immediate : yes
 
  
  handlers:
	- name: restart http
	  service
```

## configure vsftpd service to allow anonymous upload files
```
systemctl enable vsftpd 
mkdir /var/ftp/upload
chgrp ftp /var/ftp/upload
chmod g+w /var/ftp/upload
sed -i -e 's/.*anon_upload_enable=.*/anon_upload_enable=YES/ /etc/vsftpd/vsftpd.conf
```



