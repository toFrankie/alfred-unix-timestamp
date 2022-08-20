#!/bin/bash

unix_timestamp=$(date +%s)
# unix_timestamp=852048000 # 1997-01-01 00:00:00
# unix_timestamp=1660921285 # Test

# current_date=$(date -r $unix_timestamp "+%F %T")              # 当前时区时间，格式为：2022-08-19 23:01:25
# cts_date=$(TZ=Asia/Shanghai date -r $unix_timestamp "+%F %T") # 北京时间，格式为：2022-08-19 23:01:25
# utc_date=$(date -ur $unix_timestamp "+%F %T")                 # UTC 时间，格式为：2022-08-19 15:01:25

function create_output() {
  if [ -z "$1" ]; then
    exit 1
  fi

  local timestamp=$1
  local type=('current' 'cts' 'utc')
  local arr=(
    "$(date -r "$timestamp" "+%F %T")"
    "$(TZ=Asia/Shanghai date -r "$timestamp" "+%F %T")"
    "$(date -ur "$timestamp" "+%F %T")"
  )

  local str=''
  for ((i = 0; i < ${#arr[*]}; i = i + 1)); do
    local current_type=${type[i]}
    local current_val=${arr[i]}
    local current_subtitle=''

    if [ "$current_type" = 'current' ]; then
      current_subtitle="所在时区时间"
    elif [ "$current_type" = 'cts' ]; then
      current_subtitle="北京时间"
    elif [ "$current_type" = 'utc' ]; then
      current_subtitle="UTC 时间"
    fi

    local current_str="{\"title\":\"$current_val\",\"subtitle\":\"$current_subtitle\",\"arg\":\"$current_val\"}"

    if [ -z "$str" ]; then
      str="$current_str"
    else
      str="$str, $current_str"
    fi
  done

  echo "{\"items\":[$str]}" >tmp.json
  return 0
}

create_output "$unix_timestamp"
cat tmp.json
