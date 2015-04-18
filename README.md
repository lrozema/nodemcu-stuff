# NodeMCU stuff

## DNS

The DNS is obtained from https://github.com/nodemcu/nodemcu-firmware/issues/59 and improved. It allows all requests to direct to 192.168.4.1.

## Captive portal

All the code together forms a captive portal that loads a page to control an RGB LED.

Make sure to upload the html pages and the lua files. In my current setup wifi_hotspot.lua, dns.lua and led.lua are compiled to lc files.

