led_pin = 5
key_pin = 3
gpio.mode(led_pin, gpio.OUTPUT)
gpio.mode(key_pin, gpio.INT)
gpio.write(led_pin,gpio.HIGH)
print("ON")
tmr.delay(500000)
gpio.write(led_pin,gpio.LOW)
print("OFF")
function ledTrg()
    print("led_trig")
    local i = gpio.read(led_pin)
    if (i == 0) then
        gpio.write(led_pin, gpio.HIGH)
        print("OFF")
    else
        gpio.write(led_pin, gpio.LOW)
        print("ON")
    end
end
gpio.trig(key_pin,"up", ledTrg)
--gpio.write(0,gpio.LOW)
