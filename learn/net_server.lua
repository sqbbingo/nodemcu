-- 30s time out for a inactive client
sv = net.createServer(net.TCP, 30)

function receiver(sck, data)
  print(data)
  sck:close()
end

if sv then
  sv:listen(6666,"127.0.0.1",function(conn)
    print("listen")
    conn:on("receive", receiver)
    conn:send("hello world")
  end)
end