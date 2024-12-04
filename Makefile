# vim: ts=8
# vim: sw=8
# vim: noexpandtab

# grep '^[a-z\-]*:' Makefile | cut -d: -f 1 | tr '\n' ' '
.PHONY:	 help docker-build docker-bash puma-v5 puma-v6 test test-all rubocop generate-pdf

RUBY_VERSION    		:= $(cat .ruby-version)
OS	 		 	:= $(shell uname -s | tr '[:upper:]' '[:lower:]')

# see: https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile/18137056#18137056
MAKEFILE_PATH 			:= $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR 			:= $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))
PUMAD_HOME			:= $(shell dirname $(MAKEFILE_PATH))
VERSION 			:= $(shell bundle exec ruby -I lib -r puma-daemon.rb -e 'puts Puma::Daemon::VERSION')
TAG 				:= $(shell echo "v$(VERSION)")
BRANCH          		:= $(shell git branch --show)

help:	   			## Prints help message auto-generated from the comments.
				@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

puma-v5: 			## Installs puma 5.0.0
				@echo "——————> Building for Puma v5 <—————————"
				@ln -nfs Gemfile.puma-v5 Gemfile
				@bundle install -j 4

puma-v6: 			## Installs puma 5.0.0
				@echo "——————> Building for Puma v6 <—————————"
				@ln -nfs Gemfile.puma-v6 Gemfile
				@bundle install -j 4

test:				
				@bundle exec rspec --color --format progress

test-all:			## Test all supported Puma Versions
				make puma-v5
				make test
				make puma-v6
				make test

rubocop:			## Run rubocop
				@export BUNDLE_GEMFILE=Gemfile.puma-v6
				@bundle check || bundle install -j 3
				@bundle exec rubocop --format=progress --color --parallel

ci:				test-all rubocop ## Run all checks run on CI
				

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

tag:        			## Tag with the latest .version
				@/usr/bin/env bash -c "git tag | grep -q '$(TAG)' && { echo 'Tag $(TAG) is already assigned.'; exit 1; } || true"
				@/usr/bin/env bash -c "if [[ $(BRANCH) != master ]]; then echo 'Must be on the main branch'; else git tag -f '$(TAG)'; git push --tags --force; fi"

tag-update:        		## Re-tag latest codebase with the existing version
				@/usr/bin/env bash -c "if [[ $(BRANCH) != master ]]; then echo 'Must be on the main branch'; else git tag -f '$(TAG)'; git push --tags --force; fi"
