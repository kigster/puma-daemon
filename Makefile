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

puma-v5: 			## Installs puma 5.0.0
				@ln -nfs Gemfile.puma-v5 Gemfile
				@bundle install

puma-v6: 			## Installs puma 5.0.0
				@ln -nfs Gemfile.puma-v6 Gemfile
				@bundle install

test:				## Runs the test suite
				@bundle exec rspec

test-all:			## Test all supported Puma Versions
				make puma-v5
				make test
				make puma-v6
				make test

rubocop:			## Run rubocop
				@bundle check || bundle install
				@bundle exec rubocop --format=progress

				
docker-build-ruby:		## Builds the Docker image by compiling ruby 3.0.0
				@docker build -f Dockerfile.build    -t puma-daemon:latest .

docker-download-ruby:		## Builds the Docker image by downloading ruby 3.0.0 image
				@docker build -f Dockerfile.download -t puma-daemon:latest .

docker-build-run: 		docker-build-ruby ## Drops you into a BASH session on ubuntu with ruby 3.0.0
				@docker run -it puma-daemon:latest

docker-download-run: 		docker-download-ruby ## Drops you into a BASH session on ubuntu with ruby 3.0.0
				@docker run -it puma-daemon:latest

generate-pdf:			## Regenerates README,pdf from README.adoc
				@bash -c "[[ -d ~/.bashmatic ]] || git clone https://github.com/kigster/bashmatic ~/.bashmatic"
				@bash -c "source ~/.bashmatic/init.sh && ~/.bashmatic/bin/adoc2pdf README.adoc"

clean:				## Clean-up
				@rm -rf Gemfile Gemfile.lock coverage 
 
