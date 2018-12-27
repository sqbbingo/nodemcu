
wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="led_nodemcu01", pwd="12345678", auth=wifi.WPA2_PSK})

enduser_setup.manual(true)
print("ap ip:"..wifi.ap.getip())
print("ap mac:"..wifi.ap.getmac())
print("sta mac:"..wifi.sta.getmac())
enduser_setup.start(
    function()
        print("sta ip:", wifi.sta.getip())
        wifi.setmode(wifi.STATION)
        tmr.start(wificonnect_timer)
    end,
    function(err, str)
        print("enduser_err:" .. str)
        enduser_stop()
end)

wificonnect_timer = tmr.create()
tmr.register(wificonnect_timer, 5000, 1, function () 
    if (wifi.sta.getip() == nil) then
        print("lost connect,connect againing")
        tmr.interval(wificonnect_timer,120000)
        wifi.setmode(wifi.STATIONAP)
        wifi.ap.config({ssid="led_nodemcu01", pwd="12345678", auth=wifi.WPA2_PSK})
        enduser_setup.manual(true)
        enduser_setup.start(
            function()
                print("sta ip:", wifi.sta.getip())
                wifi.setmode(wifi.STATION)
                tmr.interval(wificonnect_timer,5000)
            end,
            function(err, str)
                print("enduser_err:" .. str)
                enduser_stop()
        end)

    end
end)

