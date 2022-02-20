# find high  CPU utilization 
```
top -n 1 -b -o +%CPU | head -n 10'
```

# fnd high program with memroy utilization 
```
top -n 1 -b -o +%MEM | head -n 10
```
