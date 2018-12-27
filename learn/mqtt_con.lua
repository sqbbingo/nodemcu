wifi_led_pin = 5
gpio.mode(wifi_led_pin,gpio.OUTPUT)
m = mqtt.Client("Node_MM", 30)

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

m:lwt("node_mm", "lwt", 0, 0)
m:on("connect", function(client) 
    m:publish("node_mm", "online", 0, 0)
    m:subscribe("pc_mm", 0, function(client) 
        print("subscribe success")
    end)
end)
m:on("offline", function(client)
    print("offline")
end)

m:on("message", function(client, topic, data)
    print(topic .. ": ")
    if data ~= nil then
        print(data)
        print(string.len(data))
        led_con(data)
    end
end)

m:connect("iot.eclipse.org")