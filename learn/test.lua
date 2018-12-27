local myIO = require "myIO"
myIO.gpioInit()

function a()
    print("short")
end

function b()
    print("long")
end

myIO.setKey(a, b)