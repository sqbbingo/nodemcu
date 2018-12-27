wifi.setmode(wifi.STATIONAP)
cfg={}
cfg.ssid="led_nodemcu01"
cfg.pwd="12345678"
wifi.ap.config(cfg)

web = '<!doctype html><html><head><meta charset=\'utf-8\'><meta name=\'viewport\'content=\'width=380\'><title>Connect gadget to you WiFi</title><style media=\'screen\'type=\'text/css\'>*{margin:0;padding:0}html{height:100%;background:linear-gradient(rgba(196,102,0,0.2),rgba(155,89,182,0.2)),url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAAA8AgMAAACm+SSwAAAADFBMVEVBR1FFS1VHTlg8Q0zU/YXIAAADVElEQVQ4yy1TTYvTUBQ9GTKiYNoodsCF4MK6U4TZChOhiguFWHyBFzqlLl4hoeNvEBeCrlrhBVKq1EUKLTP+hvi1GyguXqBdiZCBzGqg20K8L3hDQnK55+OeJNguHx6UujYl3dL5ALn4JOIUluAqeAWciyGaSdvngOWzNT+G0UyGUOxVOAdqkjXDCbBiUyjZ5QzYEbGadYAi6kHxth+kthXNVNCDofwhGv1D4QGGiM9iAjbCHgr2iUUpDJbs+VPQ4xAr2fX7KXbkOJMdok965Ksb+6lrjdkem8AshIuHm9Nyu19uTunYlOXDTQqi8VgeH0kBXH2xq/ouiMZPzuMukymutrBmulUTovC6HqNFW2ZOiqlpSXZOTvSUeUPxChjxol8BLbRy4gJuhV7OR4LRVBs3WQ9VVAU7SXgK2HeUrOj7bC8YsUgr3lEV/TXB7hK90EBnxaeg1Ov15bY80M736ekCGesGAaGvG0Ct4WRkVQVHIgIM9xJgvSFfPay8Q6GNv7VpR7xUnkvhnMQCJDYkYOtNLihV70tCU1Sk+BQrpoP+HLHUrJkuta40C6LP5GvBv+Hqo10ATxxFrTPvNdPr7XwgQud6RvQN/sXjBGzqbU27wcj9cgsyvSTrpyXV8gKpXeNJU3aFl7MOdldzV4+HfO19jBa5f2IjWwx1OLHIvFHkqbBj20ro1g7nDfY1DpScvDRUNARgjMMVO0zoMjKxJ6uWCPP+YRAWbGoaN8kXYHmLjB9FXLGOazfFVCvOgqzfnicNPrHtPKlex2ye824gMza0cTZ2sS2Xm7Qst/UfFw8O6vVtmUKxZy9xFgzMys5cJ5fxZw4y37Ufk1Dsfb8MqOjYxE3ZMWxiDcO0PYUaD2ys+8OW1pbB7/e3sfZeGVCL0Q2aMjjPdm2sxADuejZxHJAd8dO9DSUdA0V8/NggRRanDkBrANn8yHlEQOn/MmwoQfQF7xgmKDnv520bS/pgylP67vf3y2V5sCwfoCEMkZClgOfJAFX9eXefR2RpnmRs4CDVPceaRfoFzCkJVJX27vWZnoqyvmtXU3+dW1EIXIu8Qg5Qta4Zlv7drUCoWe8/8MXzaEwux7ESE9h6qnHj3mIO0/D9RvzfxPmjWiQ1vbeSk4rrHwhAre35EEVaAAAAAElFTkSuQmCC)}body{font-family:arial,verdana}div{position:absolute;margin:auto;top:0;right:0;bottom:0;left:0;width:320px;height:274px}form{width:320px;text-align:center;position:relative}form fieldset{background:white;border:0 none;border-radius:5px;box-shadow:0 0 15px 1px rgba(0,0,0,0.4);padding:20px 30px;box-sizing:border-box}form input{padding:15px;border:1px solid#ccc;border-radius:3px;margin-bottom:10px;width:100%;box-sizing:border-box;font-family:montserrat;color:#2C3E50;font-size:13px}form.action-button{width:100px;background:#27AE60;font-weight:bold;color:white;border:0 none;border-radius:3px;cursor:pointer;padding:10px 5px;margin:10px 5px}form.action-button:hover,#msform.action-button:focus{box-shadow:0 0 0 2px white,0 0 0 3px#27AE60}.fs-title{font-size:15px;text-transform:uppercase;color:#2C3E50;margin-bottom:10px}.fs-subtitle{font-weight:normal;font-size:13px;color:#666;margin-bottom:20px}</style></head><body><div><form><fieldset><h2 class=\'fs-title\'>WiFi Login</h2><h3 class=\'fs-subtitle\'>Connect gadget to your WiFi</h3><input type=\'text\'autocorrect=\'off\'autocapitalize=\'none\'name=\'wifi_ssid\'placeholder=\'WiFi Name\'/><input type=\'password\'name=\'wifi_password\'placeholder=\'Password\'/><input type=\'submit\'name=\'save\'class=\'submit action-button\'value=\'Save\'/></fieldset></form></div></body></html>'    

sendBuf = {}

for i = 1, #web, 1400 do
    local len = #web - i 
    if len > 1400 then
        sendBuf[#sendBuf + 1] = string.sub(web, i, i+1400-1)
    else
        sendBuf[#sendBuf + 1] = string.sub(web, i, i+len)
    end
end

function sendWeb(c)
    if #sendBuf > 0 then
        s = table.remove(sendBuf, 1)
        c:send(s)
    else
        c:close()
    end
end

sv = net.createServer(net.TCP, 60)

sv:listen(80, function(c)
    c:on("receive", function(cn, req)
        local _, _, method, path, vars = string.find(req, "([A-Z]+) (.+)?(.+) HTTP")
        if method == nil then
            _, _, method, path = string.find(req, "([A-Z]+) (.+) HTTP")
        end

        local _GET = {}
        if vars ~= nil then
            for k, v in string.gmatch(vars, "(%w+_%w+)=(%w+)&*") do
                _GET[k] = v
                print(k .. ":" .. v)
            end        
            local sendbuf = "<h1>Config Succeed!</h1>"
            sendbuf = sendbuf.."<p>wifi_ssid: ".._GET["wifi_ssid"].."</P>"
            sendbuf = sendbuf.."<p>wifi_password  :".._GET["wifi_password"].."</P>"
            cn:send(sendbuf)
            cn:close()
        else
            cn:on("sent", sendWeb)
            sendWeb(cn)
        end
    end)
end)