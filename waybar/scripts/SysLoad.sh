#!/bin/bash

output=$(top -bn1)

cpu_usage=$(echo "$output" | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%.1f", 100 - $1}')
mem_info=$(echo "$output" | grep "MiB Mem" | awk '{used=$8; printf "%.1f GiB", used/1024}')

output=$(cat <<EOF
{"text": "${cpu_usage}%, ${mem_info}"}
EOF
)
echo "${output}"
