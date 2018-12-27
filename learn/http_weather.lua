weather = {}
mt = {}
t = {metatable = mt}
mt.__newindex = function(table, key, value)
    if 
    (key == "temperature") or 
    (key == "skycon") or 
    (key == "humidity") or 
    (key == "pm25")
    then
        rawset(weather, key, value)
    end
end

obj = sjson.decoder(t)

http.get("http://api.caiyunapp.com/v2/TAkhjf8d1nlSlspN/113.373,23.0411/realtime.json", nil, function(code, data)
    if (code < 0) then
        print("http request failed")
    else
        print(data)
        obj:write(data)
        for k, v in pairs(weather) do
            print(k, v)
        end     
    end 
end)