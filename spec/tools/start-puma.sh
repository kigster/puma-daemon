#!/usr/bin/env bash

source ${BASHMATIC_HOME}/init.sh

hl.green "Cleaning stale pumas..."

ps -ef | egrep '([p]uma|[t]ail -f)' && {
  pkill puma
  pkill tail
  pkill -9 puma
  pkill -9 tail
  sleep 1
}

hl.green "Cleaning logs..."
rm -rf log
mkdir -p log
(sleep 2 && tail -f log/*) &

hl.green "Starting Pumad"

set -x
bundle exec exe/pumad $* -v --debug  -C $(pwd)/config/puma_single.rb
set +x

sleep 5

hr; echo
info "Processes:"
pumas=$(ps -ef | grep [p]uma | grep -v tail | wc -l)
((pumas))  || { 
  error "No puma processes are running."
  exit 1
}

success "Total of ${pumas} puma processes are up."
exit 0

