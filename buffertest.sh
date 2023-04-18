#!/bin/bash

# Save the current rmem_max and wmem_max values
current_rmem_max=$(sysctl -n net.core.rmem_max)
current_wmem_max=$(sysctl -n net.core.wmem_max)

# Test different values for net.core.rmem_max and net.core.wmem_max
for rmem_max in 262144 524288 1048576 2097152 4194304 8388608 16777216; do
    for wmem_max in 262144 524288 1048576 2097152 4194304 8388608 16777216; do

        # Apply the new buffer sizes
        echo "sysctl -w net.core.rmem_max=$rmem_max"
        echo "sysctl -w net.core.wmem_max=$wmem_max"
        sysctl -w net.core.rmem_max=$rmem_max
        sysctl -w net.core.wmem_max=$wmem_max

        # Restart nginx and php-fpm services
        systemctl restart --quiet nginx php-fpm

        # Run the ss command every second to collect socket statistics and save the output to a file
        if [ -f "ss_output-rmem_max-${rmem_max}-wmem_max-${wmem_max}.log" ]; then
            rm -f "ss_output-rmem_max-${rmem_max}-wmem_max-${wmem_max}.log"
        fi
        while true; do
        ss -e -t -i -p "( sport = :80 or sport = :9000 )" | awk '
BEGIN {
    printf "[";
    isFirst = 1;
}
NR>1 {
    if (isFirst) {
        isFirst = 0;
    } else {
        printf ",";
    }

    printf "{\"state\": \"%s\", \"local_address_port\": \"%s\", \"peer_address_port\": \"%s\", \"uid\": \"%s\"", $1, $4, $5, $8;

    for (i = 9; i <= NF; i++) {
        split($i, kv, ":");
        if (length(kv) == 2) {
            key = kv[1];
            value = kv[2];
            gsub(/[^a-zA-Z0-9]/, "", key);
            gsub(/[^a-zA-Z0-9.\/]/, "", value);
            printf ", \"%s\": \"%s\"", key, value;
        }
    }

    printf "}";
}
END {
    printf "]\n";
}
' >> ss_output-rmem_max-${rmem_max}-wmem_max-${wmem_max}.log
        sleep 1
        done &
        ss_pid=$!

        # Run a benchmark to test the performance
        echo "wrk -t2 -c100 -d3s --breakout -s /root/tools/wrk-cmm/scripts/json.lua http://localhost/index.php"
        test_output=$(wrk -t2 -c100 -d3s --breakout -s /root/tools/wrk-cmm/scripts/json.lua http://localhost/index.php)
        test_output_json=$(echo "$test_output"| awk '/^{/,0{if($0 !~ /^[-]+$/){print}}' | jq .)
        echo "$test_output" | tee buffertest-rmem_max-${rmem_max}-wmem_max-${wmem_max}.log
        echo "$test_output_json" > buffertest-rmem_max-${rmem_max}-wmem_max-${wmem_max}.json

        # Wait for a few seconds to ensure ss has time to collect data
        sleep 3
        
        # Stop the ss background process
        kill $ss_pid
        
        # Wait for the ss process to finish
        wait $ss_pid
    done
done

# Revert rmem_max and wmem_max to their original values
sysctl -w net.core.rmem_max=$current_rmem_max
sysctl -w net.core.wmem_max=$current_wmem_max
