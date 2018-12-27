--[[
 
1、实现通过手机让模块连接网络功能，并初步具有断线重连接、重新选择wifi的能力
--]]
------------------------------------------------------------------------
--led_of_state

IO_BLINK = 4
TMR_BLINK = 5
gpio.mode(IO_BLINK, gpio.OUTPUT)

blink = nil
tmr.register(TMR_BLINK, 100, tmr.ALARM_AUTO, function()
    gpio.write(IO_BLINK, blink.i % 2)
    tmr.interval(TMR_BLINK, blink[blink.i + 1])
    blink.i = (blink.i + 1) % #blink
end)

function blinking(param)
    if type(param) == 'table' then
        blink = param
        blink.i = 0
        tmr.interval(TMR_BLINK, 1)
        running, _ = tmr.state(TMR_BLINK)
        if running ~= true then
            tmr.start(TMR_BLINK)
        end
    else
        tmr.stop(TMR_BLINK)
        gpio.write(IO_BLINK, param or gpio.LOW)
    end
end
--------------------------------------------------------------------
--1、通过enduser功能在手机让模块连接网络
--断线后重新选择wifi功能效果待测试

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
        blinking({2000, 100})
    end,
    function(err, str)
        print("enduser_err:" .. str)
        enduser_stop()
end)

wificonnect_timer = tmr.create()
tmr.register(wificonnect_timer, 5000, 1, function () 
    if (wifi.sta.getip() == nil) then
        print("lost connect,connect againing")
        blinking({300, 300})
        tmr.interval(wificonnect_timer,120000)
        wifi.setmode(wifi.STATIONAP)
        wifi.ap.config({ssid="led_nodemcu01", pwd="12345678", auth=wifi.WPA2_PSK})
        enduser_setup.manual(true)
        enduser_setup.start(
            function()
                print("sta ip:", wifi.sta.getip())
                wifi.setmode(wifi.STATION)
                blinking({2000, 100})
                tmr.interval(wificonnect_timer,5000)
            end,
            function(err, str)
                print("enduser_err:" .. str)
                enduser_stop()
        end)

    end
end)
tmr.start(wificonnect_timer)
-----------------------------------------------------------------------------------------

