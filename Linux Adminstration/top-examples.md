# find high  CPU utilization 
'top -n 1 -b -o +%CPU | head -n 10'
# find high program with memroy utilization 
'op -n 1 -b -o +%MEM | head -n 10'
