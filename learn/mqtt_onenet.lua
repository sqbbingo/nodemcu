wifi_led_pin = 5
gpio.mode(wifi_led_pin,gpio.OUTPUT)
m1 = mqtt.Client("509113251", 120, "194413", "Vt2rLag7l9LtcqUn7dT87psfxEY=")

function led_con(data)
    print("led_con")
    print(data)
    if (data == '1') then
        print("ON")
        gpio.write(wifi_led_pin,gpio.HIGH)
    elseif (data == '0') then
        print("OFF")
        gpio.write(wifi_led_pin,gpio.LOW)
    end
end

m1:lwt("node_mm", "lwt", 0, 0)
m1:on("connect", function(client) 
    m1:publish("node_mm", "online", 0, 0)
    m1:subscribe("pc_mm", 0, function(client) 
        print("subscribe success")
    end)
end)
m1:on("offline", function(client)
    print("offline")
end)

m1:on("message", function(client, topic, data)
    print(topic .. ": ")
    if data ~= nil then
        print(data)
        print(string.len(data))
        led_con(data)
    end
end)

m1:connect("183.230.40.39", 6002)
tmr.alarm(1,1000,1,function() m1:publish("node_mm", "online", 0, 0) end)
--tmr.alarm(1,1100,1,function() m1:publish("$dp", "oe", 0, 0) end)
