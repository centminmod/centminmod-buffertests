#!/bin/bash

# Get the list of JSON files
files=$(ls -1rt testlogs/*.json)

# Print the table header
echo "| rmem_max | wmem_max | requests | duration_in_microseconds | bytes | requests_per_sec | bytes_transfer_per_sec | 50% latency | 75% latency | 90% latency | 99% latency | 99.999% latency |"
echo "|----------|----------|----------|-------------------------|-------|-----------------|-----------------------|-------------|-------------|-------------|-------------|-----------------|"

# Loop through the files and extract the values
for file in $files; do
    rmem_max=$(echo $file | awk -F'[-]' '{print $3}')
    wmem_max=$(echo $file | awk -F'[-]' '{print $5}' | sed -e 's|.json||g')
    requests=$(jq '.requests' $file)
    duration=$(jq '.duration_in_microseconds' $file)
    bytes=$(jq '.bytes' $file)
    req_per_sec=$(jq '.requests_per_sec' $file)
    bytes_per_sec=$(jq '.bytes_transfer_per_sec' $file)
    latency_50=$(jq '.latency_distribution[] | select(.percentile == 50) | .latency_in_microseconds' $file)
    latency_75=$(jq '.latency_distribution[] | select(.percentile == 75) | .latency_in_microseconds' $file)
    latency_90=$(jq '.latency_distribution[] | select(.percentile == 90) | .latency_in_microseconds' $file)
    latency_99=$(jq '.latency_distribution[] | select(.percentile == 99) | .latency_in_microseconds' $file)
    latency_99999=$(jq '.latency_distribution[] | select(.percentile == 99.999) | .latency_in_microseconds' $file)

    # Print the row
    echo "| $rmem_max | $wmem_max | $requests | $duration | $bytes | $req_per_sec | $bytes_per_sec | $latency_50 | $latency_75 | $latency_90 | $latency_99 | $latency_99999 |"
done
