time = 0
time = tmr.now()
gpio.mode(5, gpio.OUTPUT, PULLUP)
gpio.serout(5,1,{3,7},8)
print(tmr.now() - time)
time = tmr.now()
gpio.serout(5,1,{50,50},8, 1)
print(tmr.now() - time)
