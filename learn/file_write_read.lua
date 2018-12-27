file.open("file.txt", "w")
for i=1, 3, 1 do
    ch = "string_" .. i
    file.writeline(ch)
end
file.close()
if file.open("file.txt") then
    result = file.readline()
    while result ~= nil 
    do 
        print(result)
        result = file.readline()
    end
end
file.close()