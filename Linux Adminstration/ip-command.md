Modify Network Interface Status

```
ip link set eth0 up
ip link set eth0 down
```

You can select between IPv4 and IPv6 using the following syntax: 
```
### Only show TCP/IP IPv4  ##
ip -4 a
 
### Only show TCP/IP IPv6  ###
ip -6 a
```
It is also possible to specify and list particular interface TCP/IP details:
```
### Only show eth0 interface ###
ip a show eth0
ip a list eth0
ip a show dev eth0
 
### Only show running interfaces ###
ip link ls up
```


# Assigns the IP address to the interface

The syntax is as follows to add an IPv4/IPv6 address:
```
ip a add {ip_addr/mask} dev {interface}
```
To assign 192.168.1.200/255.255.255.0 to eth0, enter:
```
ip a add 192.168.1.200/255.255.255.0 dev eth0
```
# Remove / Delete the IP address from the interface

The syntax is as follows to remove an IPv4/IPv6 address:
```
ip a del {ipv6_addr_OR_ipv4_addr} dev {interface}
```
To delete 192.168.1.200/24 from eth0, enter:
```
ip a del 192.168.1.200/24 dev eth0
```

# Add route on Linux system
two format can be apply
```
ip route add {NETWORK/MASK} via {GATEWAYIP}
ip route add {NETWORK/MASK} dev {DEVICE}
```

for example
```
ip route add 192.168.1.0/24 via 192.168.1.254
ip route add 192.168.1.0/24 dev eth0
```
