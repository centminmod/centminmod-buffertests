# setup

* https://github.com/centminmod/wrk/tree/centminmod

```
git clone -b centminmod https://github.com/centminmod/wrk wrk-cmm
cd wrk-cmm
make
\cp -af wrk /usr/local/bin/wrk-cmm
ln -s /usr/local/bin/wrk-cmm /usr/local/bin/wrk
```
```
echo > /usr/local/nginx/html/index.php
nprestart
curl -I http://localhost/index.php
```

# benchmark run

```
git clone https://github.com/centminmod/centminmod-buffertests
cd centminmod-buffertests
time ./buffertest.sh
```

The `buffertest.sh` by default logs `ss` stats for port `80` and PHP-FPM port `9000` according to `ss -e -t -i -p "( sport = :80 or sport = :9000 )"`. If you plan to test with HTTPS port `443`, adjust accordingly.

Output for `testlogs/buffertest-rmem_max-16777216-wmem_max-16777216.log`


```
cat testlogs/buffertest-rmem_max-16777216-wmem_max-16777216.log
Running 3s test @ http://localhost/index.php
  2 threads and 100 connections
  Thread Stats   Avg     Stdev       Max       Min   +/- Stdev
    Latency     3.03ms    1.34ms   16.26ms  218.00us   79.18%
    Connect   692.49us  380.32us    1.45ms   82.00us   57.00%
    TTFB        3.02ms    1.34ms   16.26ms  216.00us   79.21%
    TTLB        3.19us   36.20us    7.47ms    0.00us   99.26%
    Req/Sec    16.30k     1.34k    19.50k    12.15k    78.33%
  97397 requests in 3.01s, 21.74MB read
Requests/sec:  32394.33
Transfer/sec:      7.23MB

JSON Output
-----------

{
        "requests": 97397,
        "duration_in_microseconds": 3006606.00,
        "bytes": 22790898,
        "requests_per_sec": 32394.33,
        "bytes_transfer_per_sec": 7580274.24,
        "latency_distribution": [
                {
                        "percentile": 50,
                        "latency_in_microseconds": 2960
                },
                {
                        "percentile": 75,
                        "latency_in_microseconds": 3716
                },
                {
                        "percentile": 90,
                        "latency_in_microseconds": 4311
                },
                {
                        "percentile": 99,
                        "latency_in_microseconds": 8215
                },
                {
                        "percentile": 99.999,
                        "latency_in_microseconds": 16261
                }
        ]
}
```

JSON output only

```
cat testlogs/buffertest-rmem_max-16777216-wmem_max-16777216.json 
{
  "requests": 97397,
  "duration_in_microseconds": 3006606.00,
  "bytes": 22790898,
  "requests_per_sec": 32394.33,
  "bytes_transfer_per_sec": 7580274.24,
  "latency_distribution": [
    {
      "percentile": 50,
      "latency_in_microseconds": 2960
    },
    {
      "percentile": 75,
      "latency_in_microseconds": 3716
    },
    {
      "percentile": 90,
      "latency_in_microseconds": 4311
    },
    {
      "percentile": 99,
      "latency_in_microseconds": 8215
    },
    {
      "percentile": 99.999,
      "latency_in_microseconds": 16261
    }
  ]
}
```

# Generate table

The `buffertest.sh` run will generate wrk JSON log files:

```
ls -1rt testlogs/*.json
testlogs/buffertest-rmem_max-262144-wmem_max-262144.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216.json
```

The `generate-table.sh` script will aggregrate all the work JSON log files into a markdown format table:

```
./generate-table.sh

| rmem_max | wmem_max | requests | duration_in_microseconds | bytes | requests_per_sec | bytes_transfer_per_sec | 50% latency | 75% latency | 90% latency | 99% latency | 99.999% latency |
|----------|----------|----------|-------------------------|-------|-----------------|-----------------------|-------------|-------------|-------------|-------------|-----------------|
| 262144 | 262144 | 39253 | 3001496.00 | 9185202 | 13077.81 | 3060207.98 | 8088 | 8472 | 8824 | 9732 | 15000 |
| 524288 | 524288 | 99427 | 3100751.00 | 23265918 | 32065.46 | 7503317.10 | 2962 | 3759 | 4312 | 7770 | 22129 |
| 1048576 | 1048576 | 97842 | 3010570.00 | 22895028 | 32499.49 | 7604881.47 | 2849 | 3605 | 4296 | 9641 | 19495 |
| 2097152 | 2097152 | 100218 | 3104021.00 | 23451012 | 32286.51 | 7555042.96 | 2897 | 3725 | 4332 | 10921 | 32713 |
| 4194304 | 4194304 | 94322 | 3044799.00 | 22071348 | 30978.07 | 7248868.64 | 2826 | 3592 | 4837 | 45796 | 73840 |
| 8388608 | 8388608 | 97785 | 3001677.00 | 22881690 | 32576.79 | 7622968.76 | 2824 | 3598 | 4303 | 10180 | 25101 |
| 16777216 | 16777216 | 97309 | 3004353.00 | 22770306 | 32389.34 | 7579104.72 | 2916 | 3700 | 4315 | 9228 | 20413 |
```

| rmem_max | wmem_max | requests | duration_in_microseconds | bytes | requests_per_sec | bytes_transfer_per_sec | 50% latency | 75% latency | 90% latency | 99% latency | 99.999% latency |
|----------|----------|----------|-------------------------|-------|-----------------|-----------------------|-------------|-------------|-------------|-------------|-----------------|
| 262144 | 262144 | 39253 | 3001496.00 | 9185202 | 13077.81 | 3060207.98 | 8088 | 8472 | 8824 | 9732 | 15000 |
| 524288 | 524288 | 99427 | 3100751.00 | 23265918 | 32065.46 | 7503317.10 | 2962 | 3759 | 4312 | 7770 | 22129 |
| 1048576 | 1048576 | 97842 | 3010570.00 | 22895028 | 32499.49 | 7604881.47 | 2849 | 3605 | 4296 | 9641 | 19495 |
| 2097152 | 2097152 | 100218 | 3104021.00 | 23451012 | 32286.51 | 7555042.96 | 2897 | 3725 | 4332 | 10921 | 32713 |
| 4194304 | 4194304 | 94322 | 3044799.00 | 22071348 | 30978.07 | 7248868.64 | 2826 | 3592 | 4837 | 45796 | 73840 |
| 8388608 | 8388608 | 97785 | 3001677.00 | 22881690 | 32576.79 | 7622968.76 | 2824 | 3598 | 4303 | 10180 | 25101 |
| 16777216 | 16777216 | 97309 | 3004353.00 | 22770306 | 32389.34 | 7579104.72 | 2916 | 3700 | 4315 | 9228 | 20413 |

# ss json output explained

* `state`: the current state of the TCP connection
* `local_address_port`: the local IP address and port number of the connection
* `peer_address_port`: the peer IP address and port number of the connection
* `uid`: the user ID that owns the socket
* `pmtu`: the Path Maximum Transmission Unit (PMTU) of the connection
* `rcvmss`: the maximum segment size that can be received by the connection
* `advmss`: the maximum segment size that can be advertised by the connection
* `cwnd`: the size of the congestion window
* `ssthresh`: the slow start threshold
* `bytessent`: the total number of bytes sent by the connection
* `bytesretrans`: the total number of bytes retransmitted by the connection
* `bytesacked`: the total number of bytes acknowledged by the receiver
* `bytesreceived`: the total number of bytes received by the connection
* `segsout`: the total number of segments sent by the connection
* `segsin`: the total number of segments received by the connection
* `datasegsout`: the total number of data segments sent by the connection
* `datasegsin`: the total number of data segments received by the connection
* `lastsnd`: the timestamp of the last segment sent by the connection
* `lastrcv`: the timestamp of the last segment received by the connection
* `lastack`: the timestamp of the last acknowledgment received by the connection
* `delivered`: the total number of segments delivered to the application
* `busy`: the duration of the connection in milliseconds
* `retrans`: the number of retransmissions and the total number of segments transmitted
* `dsackdups`: the number of duplicate selective acknowledgments received by the connection
* `reordseen`: the number of reordered segments received by the connection
* `rcvrtt`: the estimated round trip time of the connection
* `rcvspace`: the receive window size of the connection
* `rcvssthresh`: the receive slow start threshold of the connection
* `minrtt`: the minimum round trip time of the connection
* `sndwnd`: the send window size of the connection

```
cat testlogs/ss_output-rmem_max-16777216-wmem_max-16777216.log | jq -c '.[]' | tail -4 | jq -r

{
  "state": "FIN-WAIT-1",
  "local_address_port": "127.0.0.1:9000",
  "peer_address_port": "127.0.0.1:45608",
  "uid": "ino:33512991",
  "sk": "8e4f"
}
{
  "state": "ts",
  "local_address_port": "wscale:9,9",
  "peer_address_port": "rto:201",
  "uid": "mss:22016",
  "pmtu": "65535",
  "rcvmss": "808",
  "advmss": "65483",
  "cwnd": "10",
  "bytessent": "72",
  "bytesacked": "72",
  "bytesreceived": "808",
  "segsout": "3",
  "segsin": "4",
  "datasegsout": "1",
  "datasegsin": "1",
  "delivered": "2",
  "unacked": "1",
  "rcvrtt": "1",
  "rcvspace": "43690",
  "rcvssthresh": "45306",
  "minrtt": "0.013",
  "sndwnd": "44032"
}
{
  "state": "ESTAB",
  "local_address_port": "127.0.0.1:http",
  "peer_address_port": "127.0.0.1:15918",
  "uid": "ino:33375789",
  "sk": "e47d"
}
{
  "state": "ts",
  "local_address_port": "wscale:9,9",
  "peer_address_port": "rto:201",
  "uid": "mss:65483",
  "pmtu": "65535",
  "rcvmss": "536",
  "advmss": "65483",
  "cwnd": "10",
  "bytessent": "124254",
  "bytesacked": "124254",
  "bytesreceived": "23408",
  "segsout": "532",
  "segsin": "535",
  "datasegsout": "531",
  "datasegsin": "532",
  "lastsnd": "3",
  "lastrcv": "1",
  "lastack": "1",
  "delivered": "532",
  "busy": "349ms",
  "rcvspace": "43690",
  "rcvssthresh": "43690",
  "minrtt": "0.008",
  "sndwnd": "613376"
}
```