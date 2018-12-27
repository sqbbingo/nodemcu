function isConnect()
    ip, _, _ = wifi.sta.getip()
    if ip ~= nil then
        print(ip)
        return true
    else
        print("without ip")
        return false
    end
end

function refreshTime()
    time = rtctime.epoch2cal(rtctime.get())
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d", 
                        time["year"], 
                        time["mon"], 
                        time["day"], 
                        time["hour"] + 8, 
                        time["min"], 
                        time["sec"]))
end

tmr.alarm(0, 1000, tmr.ALARM_AUTO, function() 
    if isConnect() == true then
        tmr.stop(0)
        sntp.sync("202.120.2.101", 
            function()
                print("sync succeeded")
                tmr.alarm(0, 1000, tmr.ALARM_AUTO, refreshTime)
            end,
            function(index)
                print("failed : "..index)
            end
        )
    end
end)