ws2812.init()
i, buffer = 0, ws2812.newBuffer(16, 3); 
buffer:fill(0, 0, 0);
tmr.alarm(0, 50, 0, function()
        i = i + 1
        buffer:fade(2)
        buffer:set(i%buffer:size() + 1, 0, 0, 100)
        ws2812.write(buffer)
end)