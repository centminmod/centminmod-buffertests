#!/bin/bash

# Specify the number of runs for calculating the average
num_runs=5

# Get the list of JSON files
files=$(ls -1rt testlogs/*.json)

# Print the table header
echo "| rmem_max | wmem_max | run | requests | duration_in_microseconds | bytes | requests_per_sec | bytes_transfer_per_sec | 50% latency | 75% latency | 90% latency | 99% latency | 99.999% latency |"
echo "|----------|----------|-----|----------|-------------------------|-------|-----------------|-----------------------|-------------|-------------|-------------|-------------|-----------------|"

# Initialize variables for calculating averages
count=0
sum_requests=0
sum_duration=0
sum_bytes=0
sum_req_per_sec=0
sum_bytes_per_sec=0
sum_latency_50=0
sum_latency_75=0
sum_latency_90=0
sum_latency_99=0
sum_latency_99999=0

# Loop through the files and extract the values
for file in $files; do
    rmem_max=$(echo $file | awk -F'[-]' '{print $3}')
    wmem_max=$(echo $file | awk -F'[-]' '{print $5}')
    run=$(echo $file | awk -F'[-]' '{print $6}' | sed -e 's|.json||g')
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
    echo "| $rmem_max | $wmem_max | $run | $requests | $duration | $bytes | $req_per_sec | $bytes_per_sec | $latency_50 | $latency_75 | $latency_90 | $latency_99 | $latency_99999 |"

    # Update the sum variables
    count=$((count + 1))
    sum_requests=$((sum_requests + requests))
    sum_duration=$(echo "$sum_duration + $duration" | bc)
    sum_bytes=$((sum_bytes + bytes))
    sum_req_per_sec=$(echo "$sum_req_per_sec + $req_per_sec" | bc)
    sum_bytes_per_sec=$(echo "$sum_bytes_per_sec + $bytes_per_sec" | bc)
    sum_latency_50=$(echo "$sum_latency_50 + $latency_50" | bc)
    sum_latency_75=$(echo "$sum_latency_75 + $latency_75" | bc)
    sum_latency_90=$(echo "$sum_latency_90 + $latency_90" | bc)
    sum_latency_99=$(echo "$sum_latency_99 + $latency_99" | bc)
    sum_latency_99999=$(echo "$sum_latency_99999 + $latency_99999" | bc)

    # Calculate and print the average row after every $num_runs rows
    if [ $count -eq $num_runs ]; then
        avg_requests=$(echo "scale=2; $sum_requests / $num_runs" | bc)
        avg_duration=$(echo "scale=2; $sum_duration / $num_runs" | bc)
        avg_bytes=$(echo "scale=2; $sum_bytes / $num_runs" | bc)
        avg_req_per_sec=$(echo "scale=2; $sum_req_per_sec / $num_runs" | bc)
        avg_bytes_per_sec=$(echo "scale=2; $sum_bytes_per_sec / $num_runs" | bc)
        avg_latency_50=$(echo "scale=2; $sum_latency_50 / $num_runs" | bc)
        avg_latency_75=$(echo "scale=2; $sum_latency_75 / $num_runs" | bc)
        avg_latency_90=$(echo "scale=2; $sum_latency_90 / $num_runs" | bc)
        avg_latency_99=$(echo "scale=2; $sum_latency_99 / $num_runs" | bc)
        avg_latency_99999=$(echo "scale=2; $sum_latency_99999 / $num_runs" | bc)

        echo "| $rmem_max | $wmem_max | avg | $avg_requests | $avg_duration | $avg_bytes | $avg_req_per_sec | $avg_bytes_per_sec | $avg_latency_50 | $avg_latency_75 | $avg_latency_90 | $avg_latency_99 | $avg_latency_99999 |"
    
        # Reset the count and sum variables for the next group
        count=0
        sum_requests=0
        sum_duration=0
        sum_bytes=0
        sum_req_per_sec=0
        sum_bytes_per_sec=0
        sum_latency_50=0
        sum_latency_75=0
        sum_latency_90=0
        sum_latency_99=0
        sum_latency_99999=0
    fi
    done