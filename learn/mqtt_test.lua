m = mqtt.Client("Node_MM", 120)
m:connect("iot.eclipse.org", 
  function(client) 
    print("connected")
    m:publish("test/rensanning/time", "Hello World", 0, 0) 
  end,
  function(client, reason) 
    print("fail reason" .. reason) 
  end
)