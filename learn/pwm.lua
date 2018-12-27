pwm_pin = 5
flag = 1   
j = 1
pwm.setup(5,100,102)
pwm.start(pwm_pin)
function changduty()
    i = pwm.getduty(pwm_pin)
    if  (i ==1023)   then  
        j = -1              
    elseif  (i == 0)    then
        j = 1              
    end
    pwm.setduty(pwm_pin,i+j)
   
end
tmr.alarm(5,9,1,changduty)