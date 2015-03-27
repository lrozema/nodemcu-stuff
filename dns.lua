-- This code is probably not MIT, for copyright look somewhere here:
--   https://svn.nmap.org/!svn/bc/31535/nmap-exp/d33tah/lua-exec-examples/ncat/scripts/dns.lua
--   https://github.com/nodemcu/nodemcu-firmware/issues/59

s=net.createServer(net.UDP)
s:on("receive",function(s,c) 
    transaction_id=string.sub(c,1,2)
    flags=string.sub(c,3,4)
    questions=string.sub(c,5,6)

    query = ""
    raw_query = ""
    j=13
    while true do
        byte = string.sub(c,j,j)
        j=j+1
        raw_query = raw_query .. byte
        if byte:byte(1)==0x00 then --NULL marks end of the string.
            break
        end
        for i=1,byte:byte(1) do
            byte = string.sub(c,j,j)
            j=j+1
            raw_query = raw_query .. byte
            query = query .. byte
        end
        query = query .. '.'
    end
    query=query:sub(1,query:len()-1) --strip the trailing dot.
    print(query)
    q_type = string.sub(c,j,j+1)
    j=j+2
    if q_type == string.char(0)..string.char(1) then
        --print("Got a type A query "..query)
        class = string.sub(c,j,j+1)

        ip=string.char(192)..string.char(168)..string.char(4)..string.char(1)
        answers = string.char(0)..string.char(1)
        flags = string.char(0x81)..string.char(0x80)

        resp=transaction_id..flags..questions..answers..string.char(0)..string.char(0)..string.char(0)..string.char(0)..raw_query..q_type..class
        resp=resp..string.char(0xC0)..string.char(0x0C)..q_type..class..string.char(0)..string.char(0)..string.char(0)..string.char(0xDA)..string.char(0)..string.char(4)..ip
        s:send(resp)
    end
end) 
s:on("sent",function(s) 
    s:close() 
    s:listen(53)
end)
s:listen(53)

