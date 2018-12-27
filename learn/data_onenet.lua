function onenetstr(json)
    buf = {}
    buf[0] = 0x03 -- Byte1 Type=3
    jsonlength = string.len(json)
    buf[1] = bit.rshift(bit.band(jsonlength, 0xFF00), 8) 
    buf[2] = bit.band(jsonlength, 0xFF) + 1 
    return string.char(buf[0])..string.char(buf[1])..string.char(buf[2])..json.."\r" 
end
ledtable = {}
ledtable.ledR="100"
ledtable.ledB="50"
ledtable.ledG="150"

ok, json = pcall(sjson.encode, ledtable)
if ok then
  print(json)
else
  print("failed to encode!")
end
m1:publish("$dp",onenetstr(json), 0, 0)
print(onenetstr(json))