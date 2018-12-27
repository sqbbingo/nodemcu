wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid="Tenda"
station_cfg.pwd="123456789ww"
station_cfg.save=false
wifi.sta.config(station_cfg)
tmr.alarm(0,9000,0,function() print(wifi.sta.getip()) end)
