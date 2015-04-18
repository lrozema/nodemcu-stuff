
TTY = /dev/tty.Repleo-CH341-00002014
UPL = ../nodemcu-uploader/nodemcu-uploader.py --port $(TTY)

uploader:
	$(UPL) $(A)

upload_all:
	$(UPL) upload *.lua *.html --verify

upload:
	$(UPL) upload $(F) --verify

upload_compile:
	$(UPL) upload $(F) --verify --compile

download:
	$(UPL) download $(F)

filelist:
	$(UPL) file list

terminal:
	miniterm.py $(TTY) --dtr=1

.PHONY: upload_all upload terminal filelist download upload_compile

