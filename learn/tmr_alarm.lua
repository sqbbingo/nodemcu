count = 0
function print_count()
    count = count + 1
    print("count = ",count)
end
tmr.alarm(0,1000,0,print_count)
