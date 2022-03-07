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
