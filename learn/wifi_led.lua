--wifi_light.lua
wifi.setmode(wifi.STATIONAP)
station_cfg={}
station_cfg.ssid="bingo"
station_cfg.pwd="1507300136"
if (wifi.sta.getip() == nil) then
    wifi.sta.config(station_cfg)
    print("sta...conning")
end

cfg={}
cfg.ssid="led_nodemcu01"
cfg.pwd="12345678"
if (wifi.ap.getip() == nil) then
    wifi.ap.config(cfg)
    print("ap...making")
end

print(wifi.sta.getip())
led1 = 0
gpio.mode(led1, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    print("listen")
    conn:on("receive", function(client,request)
            print("receive: ",request)
            local buf = "";
            local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
            if(method == nil)then
                _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
            end
            local _GET = {}
            if (vars ~= nil)then
                for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                    _GET[k] = v
                end
            end
            print("_GET.pin: ",_GET.pin)
            buf = buf.."<h1> ESP8266 Web Server</h1>";
            buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a> <a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
            if(_GET.pin == "ON1")then
                gpio.write(led1, gpio.LOW);
            elseif(_GET.pin == "OFF1")then
                gpio.write(led1, gpio.HIGH);
            end
            
            client:send(buf);
            tmr.delay(1000)
            --client:close();
            collectgarbage();
            --
    end)
    conn:on("connection",function(skt,msg) 
        print("connection")
        local buf = "";
        buf = buf.."<h1> ESP8266 Web Server</h1>";
        buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a> <ahref=\"?pin=OFF1\"><button>OFF</button></a></p>";
        --skt:send(buf)
    end)
    conn:on("disconnection",function(skt,msg) print("disconnection") end)
end)
