# vim: tabstop=8
# vim: shiftwidth=8
# vim: noexpandtab

# grep '^[a-z\-]*:' Makefile | cut -d: -f 1 | tr '\n' ' '
.PHONY:	 help docker-build docker-bash

RUBY_VERSION    		:= $(cat .ruby-version)
OS	 		 	:= $(shell uname -s | tr '[:upper:]' '[:lower:]')

# see: https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile/18137056#18137056
MAKEFILE_PATH 			:= $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR 			:= $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))
PUMAD_HOME			:= $(shell dirname $(MAKEFILE_PATH))

help:	   			## Prints help message auto-generated from the comments.
				@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-build-ruby:		## Builds the Docker image by compiling ruby 3.0.0
				@docker build -f Dockerfile.build    -t puma-daemon:latest .

docker-download-ruby:		## Builds the Docker image by downloading ruby 3.0.0 image
				@docker build -f Dockerfile.download -t puma-daemon:latest .

docker-build-run: 		docker-build-ruby ## Drops you into a BASH session on ubuntu with ruby 3.0.0
				@docker run -it puma-daemon:latest

docker-download-run: 		docker-download-ruby ## Drops you into a BASH session on ubuntu with ruby 3.0.0
				@docker run -it puma-daemon:latest

 
