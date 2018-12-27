pwm_pin = 5
flag = 1    --亮度加减标志
j = 1
pwm.setup(5,500,102)
pwm.start(pwm_pin)
function changduty()
    i = pwm.getduty(pwm_pin)
    if  (i ==1023)   then   --检测占空比是最大还是最小
        j = -1              --最大则向下减
    elseif  (i == 0)    then
        j = 1               --最小则向上加
    end
    pwm.setduty(pwm_pin,i+j)
   
end
tmr.alarm(0,2,1,changduty)