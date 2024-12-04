#!/usr/bin/env bash

source colors.sh

[[ -f single.sh ]] || {
  echo -e "${txtred}Please run this from the ./example folder.${clr}"
  exit 1
}

[[ -f ../Gemfile ]] || {
  echo -e "${txtred}Please choose either Puma v5 or Puma v6, by running:${clr}"
  echo -e "${txtgrn}make puma-v5 or make puma-v6${clr}"
  exit 2
}

echo -e "${txtblu}Ensuring your dependencies are installed...${clr}"

(
  cd .. || exit 2;
  bundle check || bundle install
) >/dev/null

[[ -d example ]] && cd example

pid=$(ps -ef | grep puma | grep example | awk '{print $2}')

[[ -n $pid ]] && kill $pid && sleep 1

echo -e "${txtblu}Starting Puma in Single mode.${clr}"

command="../exe/pumad -C $(pwd)/puma.rb -w 0"
echo "Executing:"
echo -e "${txtgrn}${command}${clr}"
eval "${command}"

echo "Verifying Puma is running"

output=$(mktemp)

set -e

curl http://0.0.0.0:9292/ > "${output}" 2>/dev/null

[[ $(cat ${output}) == "Hello World" ]] || {
  echo -e "${txtred}Invalid response:${clr}">&2
  cat ${output}
  exit 3
}

echo -e "${txtblu} Currently Running Puma Processes:$clr"

ps auxww | grep [p]uma

echo
echo -e "${txtgrn}┌────────────────────────────────────────────────────────────────────────┐"
echo -e "${txtgrn}│ Puma Daemon is UP in the Single Process mode & HTTP response is 200/OK │"
echo -e "${txtgrn}└────────────────────────────────────────────────────────────────────────┘${clr}"
echo



