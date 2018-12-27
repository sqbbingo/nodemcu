cl = net.createConnection(net.TCP, 0)
cl:connect(6666, "127.0.0.1")
cl:on("receive", function(sck, c) print(c) end)
cl:on("disconnection", function(sck, c) print("disconnection!") end)

cl:on("connection", function(sck, c) print("connect") 
    sck:send("123")
end)
