ledState = 0
pwm = 1
flag = 0
gpio.mode(0, gpio.OUTPUT)

function ledPWM() 
    if (ledState == 1) then
        ledState = 0
        gpio.write(0, gpio.HIGH)
        tmr.interval(0, 20 - pwm)
    else 
        ledState = 1
        gpio.write(0, gpio.LOW)
        tmr.interval(0, pwm)
    end
end
function changePWM()
    if(flag == 0) then
        if(pwm == 19) then
            pwm = 18
            flag = 1
        else
            pwm = pwm + 1
        end 
    else
        if(pwm == 1) then
            pwm = 2
            flag = 0
        else
            pwm = pwm - 1
        end         
    end
end

tmr.alarm(0, 1, tmr.ALARM_AUTO, ledPWM)
tmr.alarm(1, 80, tmr.ALARM_AUTO, changePWM)