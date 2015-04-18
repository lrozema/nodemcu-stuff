wifi.setmode(wifi.SOFTAP)
cfg = {}
cfg.ssid = "NodeMCU2"
cfg.pwd = "mynodemcu"
wifi.ap.config(cfg)
