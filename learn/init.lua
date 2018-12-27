led_pin = 0
flag = 1   
j = 1
wifi_state_time = 0
gpio.mode(led_pin,gpio.OUTPUT)
function changled()
    i = gpio.read(led_pin)
    if  (i ==1)   then  
        gpio.write(led_pin,gpio.LOW)             
    elseif  (i == 0)    then
        gpio.write(led_pin,gpio.HIGH)             
    end
end
sys_led_timer = tmr.create()
tmr.register(sys_led_timer,1000,1,changled)
tmr.start(sys_led_timer)

wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid="bingo"
station_cfg.pwd="1507300136"
station_cfg.save=false
wifi.sta.config(station_cfg)
wifi.sta.autoconnect(1)
wifi_state_timer = tmr.create()
tmr.register(wifi_state_timer,9000,1,function()
    ip = wifi.sta.getip()
    if (ip == nil) then
        wifi_state_time = 0
        print("wifi connect fail")
        tmr.interval(sys_led_timer,500)
    else
        if(wifi_state_time == 0) then
            print("wifi connetc success:",station_cfg.ssid,ip)
            tmr.interval(sys_led_timer,5000)
            --wifi.sta.config(station_cfg)
            wifi_state_time = 1
        end
    end 
end)
tmr.start(wifi_state_timer)
