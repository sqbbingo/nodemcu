wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="nodeMCU", pwd="12345678", auth=wifi.WPA2_PSK})

enduser_setup.manual(true)
print("ap ip:"..wifi.ap.getip())
print("ap mac:"..wifi.ap.getmac())
print("sta mac:"..wifi.sta.getmac())

enduser_setup.start(
  function()
    print("sta ip:" .. wifi.sta.getip())
    wifi.setmode(wifi.STATION)
  end,
  function(err, str)
    print("enduser_err:" .. str)
    enduser_stop()
  end
)