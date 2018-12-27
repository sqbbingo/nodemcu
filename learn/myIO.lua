--1
myIO = { }

local key, led = 3, 5
local keymode, ledmode = gpio.INPUT, gpio.OUTPUT
local keyCnt = 0
--2
local function keyScan()
    local v = gpio.read(key)

    if v == 0 then 
        keyCnt = keyCnt + 1
        if keyCnt > 50 then 
            v = 2 
            keyCnt = 0
        end
    else
        if keyCnt > 5 then 
            v = 1 
            keyCnt = 0
        else 
            v = 0 
            keyCnt = 0
        end
    end

    return v
end
--3
function myIO.gpioInit()
    gpio.mode(key, keymode)
    gpio.mode(led, ledmode)
    return true
end
--4
function myIO.setLED(s) 
    if s == true then
        gpio.write(led, gpio.LOW)
    else
        gpio.write(led, gpio.HIGH)
    end
end
--5
function myIO.setKey(short, long)
    local s = 0

    if myIO.ktimer == nil then
        myIO.ktimer = tmr.create()
    end
    
    tmr.stop(myIO.ktimer)

    --20ms
    tmr.register(myIO.ktimer, 20, tmr.ALARM_AUTO, function()
        
        local k = keyScan()
        --调整扫描频率
        if s == 1 then 
            tmr.interval(myIO.ktimer, 20)
            s = 0
        end

        if k == 1 then
            short()
        elseif k == 2 then
            long()
            tmr.interval(myIO.ktimer, 500)
            s = 1
        end
    end)

    tmr.start(myIO.ktimer)

end
--6
return myIO