# How to confiugre direcotr for auto-compete openstack commands (use root user)

1. Install bash-completion package
```
yum install bash-completion
```
genarate openstack completion file
```
openstack complete > /usr/share/bash-completion/completions/openstack
```
add in .bashrc file to be source it automaticly when user login to the system

``
source /usr/share/bash-completion/completions/openstack > /dev/null 2>&1
``
