#!/usr/bin/env bash

[[ -f single.sh ]] || {
  echo "Please run this from the ./example folder."
  exit 1
}

[[ -f ../Gemfile ]] || {
  echo "Please choose either Puma v5 or Puma v6, by running:"
  echo "make puma-v5 or make puma-v6"
  exit 2
}

echo "Ensuring your dependencies are installed..."

( 
  cd .. || exit 2;
  bundle check || bundle install
) >/dev/null

pid=$(ps -ef | grep puma | grep example | awk '{print $2}')

[[ -n $pid ]] && kill $pid && sleep 1

echo "Starting Puma in Single mode."

../exe/pumad

echo "Verifying Puma is running"

output=$(mktemp)

set -e

curl http://0.0.0.0:9292/ > "${output}" 2>/dev/null

[[ $(cat ${output}) == "Hello World" ]] || {
  echo "Invalid response:">&2
  cat ${output}
  exit 3
}

echo "Puma Daemon is running and returning the expected string."

ps -ef | grep [p]uma

