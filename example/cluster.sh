#!/usr/bin/env bash

export txtblk='\e[0;30m'
export txtred='\e[0;31m'
export txtgrn='\e[0;32m'
export txtylw='\e[0;33m'
export txtblu='\e[0;34m'
export txtpur='\e[0;35m'
export txtcyn='\e[0;36m'
export txtwht='\e[0;37m'
export clr='\e[0;0m'

[[ -f cluster.sh ]] || {
  echo -e "${txtred}Please run this from the ./example folder.${clr}"
  exit 1
}

[[ -f ../Gemfile ]] || {
  echo -e "${txtred}Please choose either Puma v5 or Puma v6, by running:${clr}"
  echo -e "${txtgrn}make puma-v5 or make puma-v6"
  exit 2
}

echo -e "${txtblu}Ensuring your dependencies are installed...${clr}"

( 
  cd .. || exit 2;
  bundle check || bundle install
) >/dev/null

pid=$(ps -ef | grep puma | grep example | awk '{print $2}')

[[ -n $pid ]] && kill $pid && sleep 1

echo -e "${txtblu}Starting Puma in cluster mode.${clr}"

command="bundle exec puma -I ../lib -C $(pwd)/puma.rb -w 4"
echo -e "${txtblu}Running Command:"
echo -e "${txtgrn}${command}${clr}"
eval "${command}"

echo -e "${txtblu}Verifying Puma is running...${clr}"

sleep 0.5

output=$(mktemp)

set -e

curl http://0.0.0.0:9292/ > "${output}" 2>/dev/null

[[ $(cat ${output}) == "Hello World" ]] || {
  echo -e "${txtred}Invalid response:${clr}">&2
  cat ${output}
  exit 3
}

echo -e "${txtgrn}Puma Daemon is running and returning the expected string.${clr}"

ps -ef | grep [p]uma

