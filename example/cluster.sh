#!/usr/bin/env bash

source colors.sh

[[ -f cluster.sh ]] || {
  echo -e "${txtred}Please run this from the ./example folder.${clr}"
  exit 1
}

if [[ -n "${BUNDLE_GEMFILE}" || -f ../Gemfile ]]; then
  echo -e "${txtgrn}OK: We have either BUNDLE_GEMFILE defined or ../Gemfile"
  [[ -z $BUNDLE_GEMFILE ]] && BUNDLE_GEMFILE=Gemfile
else
  export BUNDLE_GEMFILE=Gemfile.puma-v6
  echo -e "${txtylw}WARNING: Set BUNDLE_GEMFILE to either v5 or v6."
  echo -e "${txtylw}         Since none we set, we selected v6 for now."
  sleep 2
fi

export GEMFILE=${BUNDLE_GEMFILE}

if [[ -z ${GEMFILE} || ! -f "${GEMFILE}" ]]; then
  export GEMFILE="../${BUNDLE_GEMFILE}"
  [[ -f ${GEMFILE} ]] || {
    echo  -e "${txtred}ERROR: File [${GEMFILE}] does not exist ${clr}"
    exit 3
  }
fi

echo -e "${txtylw}Using GEMFILE: ${txtgrn}[${GEMFILE}]${clr}"
echo -e "${txtylw}Installing Bundled Gems...${clr}"

(
  cd .. || exit 2;
  export BUNDLE_GEMFILE=${BUNDLE_GEMFILE:-"Gemfile"} ;
  bundle check || bundle install
) >/dev/null

echo -e "${txtblu}Ensuring your dependencies are installed...${clr}"
sleep 1

pid=$(ps -ef | grep puma | grep example | awk '{print $2}')

[[ -n $pid ]] && kill $pid && sleep 1

echo -e "${txtblu}Starting Puma in cluster mode.${clr}"

export BUNDLE_GEMFILE=$GEMFILE

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

echo -e "${txtblu}Currently Running Puma Processes:${txtcyn}"

ps auxww | grep [p]uma

echo
echo -e "${txtgrn}┌─────────────────────────────────────────────────────────────────────────┐"
echo -e "${txtgrn}│ Puma Daemon is UP in the CLUSTER/WORKERS mode & HTTP response is 200/OK │"
echo -e "${txtgrn}└─────────────────────────────────────────────────────────────────────────┘${clr}"
echo



