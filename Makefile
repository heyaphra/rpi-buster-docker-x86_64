build:
	@docker build . | tee .buildlog

all: build
	@docker run --rm -it $(shell grep "Successfully built" .buildlog | cut -d ' ' -f 3) /bin/bash