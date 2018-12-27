count = 0
timer = tmr.create()
runTime = tmr.time()
tmr.register(timer, 1000, tmr.ALARM_AUTO, function()
    local temp = 0
    count = count + 1
    temp = tmr.time()
    print("count&runTime=", count, temp - runTime)
    runTime = temp
    if(count == 10) then
        tmr.interval(timer, 3000)
    end
    if(count == 20) then
        tmr.stop(timer)
        print(tmr.state(timer))
        print(tmr.unregister(timer))
        print(tmr.state(timer))
    end
end)
tmr.start(timer)