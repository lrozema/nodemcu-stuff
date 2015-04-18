
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client, request)
        local buf = "";

        -- Handle GET url with variables
        local _, _, method, path, vars = string.find(request, "([A-Z]+) /(.*)?(.*) HTTP");

        -- Handle GET url without variables
        if (method == nil) then
            _, _, method, path = string.find(request, "([A-Z]+) /(.*) HTTP");
        end

        -- Parse GET variables
        local _GET = {}
        if (vars ~= nil) then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end

        if (path == '') then
            path = 'index.html'
        end

        print("path: "..path)

        -- Hack for processing LED color changes
        if (_GET.r ~= nil) and (_GET.g ~= nil) and (_GET.b ~= nil) then
            led(_GET.r, _GET.g, _GET.b)
        end

        -- Handle existing file pages (maybe parse this via some kind of lookup table)
        if (string.len(path) < 20) and file.open(path, 'r') then
            print('200')

            conn:send("HTTP/1.1 200 OK\r\n")
            conn:send("Date: Wed, 25 Mar 2015 14:38:08 GMT\r\n")
            conn:send("Cache-Control: no-cache, must-revalidate, post-check=0, pre-check=0\r\n")
            conn:send("Connection: close\r\n")
            conn:send("Content-Type: text/html; charset=utf-8\r\n")
            conn:send("\r\n")

            while true do
                n = file.read(1024)
                if (n == nil) then
                    break
                end
                conn:send(n)
            end

            file.close()
        else
            print('302')

            -- Have everything that does not exist go to login page
            conn:send("HTTP/1.1 302 OK\r\n")
            conn:send("Date: Wed, 25 Mar 2015 14:38:08 GMT\r\n")
            conn:send("Connection: close\r\n")
            conn:send("Location: http://nodemcu/login.html\r\n")
            conn:send("\r\n")
            conn:send("<html><head></head><body>Redirect</body></html>\r\n")
        end
    end)
    conn:on("sent",function(conn) 
        conn:close()
        collectgarbage();
    end)
end)

