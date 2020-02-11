build:
	@docker build . | tee .buildlog

all: build
	@docker run --rm --name rpi-buster -it spidercatnat/raspbian-buster-for-x86_64 /bin/bash

