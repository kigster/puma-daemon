#!/usr/bin/env bash

source colors.sh

# Kill any process matching "puma" in the name
declare -a pids
pids=( $(ps -ef | grep [p]uma | grep -v puma: | grep -v kill-puma | grep -v grep | awk '{print $2}') )

echo -e "${txtgrn}Currently running Puma Processes:${clr}"
echo -e "${txtylw}"
ps -ef | grep [p]uma | grep -v kill-puma
echo -en "${clr}"
if [[  -z ${pids[*]} ]] ; then
  echo -e "${txtred}No puma processes were found, nothing to kill.${clr}"
else
  echo "Found the following pids matching Puma: [${pids[*]}]" 
  echo "Let the killing commence..."
  for pid in "${pids[@]}"; do
    [[ -n $(ps -p $pid) ]] && {
      echo "killing $pid..."
      kill $pid 2>/dev/null
    }
  done
  sleep 1
  for pid in "${pids[@]}"; do
    [[ -n $(ps -p $pid) ]] && {
      echo "nuking $pid..."
      kill -9 $pid 2>/dev/null
    }
  done
fi

