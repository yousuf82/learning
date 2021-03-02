# add path to multipath name
```
multipath -v2 -d
multipath -a /dev/sda
dracut --force -H --add multipath
````
reboot is required
