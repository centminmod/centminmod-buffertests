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
cat testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-1.log
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
cat testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-1.json 
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
testlogs/buffertest-rmem_max-262144-wmem_max-262144-1.json
testlogs/buffertest-rmem_max-262144-wmem_max-262144-2.json
testlogs/buffertest-rmem_max-262144-wmem_max-262144-3.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288-1.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288-2.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288-3.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576-1.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576-2.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576-3.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152-1.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152-2.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152-3.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304-1.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304-2.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304-3.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608-1.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608-2.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608-3.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-1.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-2.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-3.json
```

The `generate-table.sh` script will aggregrate all the work JSON log files into a markdown format table:

```
./generate-table.sh 

| rmem_max | wmem_max | run | requests | duration_in_microseconds | bytes | requests_per_sec | bytes_transfer_per_sec | 50% latency | 75% latency | 90% latency | 99% latency | 99.999% latency |
|----------|----------|-----|----------|-------------------------|-------|-----------------|-----------------------|-------------|-------------|-------------|-------------|-----------------|
| 262144 | 262144 | 1 | 66807 | 3002113.00 | 15632838 | 22253.33 | 5207278.34 | 3606 | 6393 | 6782 | 8246 | 19640 |
| 262144 | 262144 | 2 | 96522 | 3019552.00 | 22586148 | 31965.67 | 7479966.56 | 2934 | 3595 | 4220 | 8599 | 23334 |
| 262144 | 262144 | 3 | 97842 | 3013541.00 | 22895028 | 32467.45 | 7597383.94 | 3009 | 3553 | 4057 | 7864 | 23188 |
| 262144 | 262144 | avg | 87057.00 | 3011735.33 | 20371338.00 | 28895.48 | 6761542.94 | 3183.00 | 4513.66 | 5019.66 | 8236.33 | 22054.00 |
| 524288 | 524288 | 1 | 90517 | 3017210.00 | 21181096 | 30000.23 | 7020093.40 | 3102 | 3857 | 5119 | 134377 | 170768 |
| 524288 | 524288 | 2 | 95212 | 3002489.00 | 22279608 | 31711.02 | 7420379.56 | 2992 | 3696 | 4328 | 8806 | 21090 |
| 524288 | 524288 | 3 | 97703 | 3007289.00 | 22862502 | 32488.73 | 7602362.79 | 2967 | 3563 | 4074 | 7142 | 15402 |
| 524288 | 524288 | avg | 94477.33 | 3008996.00 | 22107735.33 | 31399.99 | 7347611.91 | 3020.33 | 3705.33 | 4507.00 | 50108.33 | 69086.66 |
| 1048576 | 1048576 | 1 | 82230 | 3100660.00 | 19241820 | 26520.16 | 6205717.49 | 3707 | 4896 | 5379 | 6936 | 16065 |
| 1048576 | 1048576 | 2 | 96603 | 3017592.00 | 22605102 | 32013.27 | 7491106.15 | 2932 | 3643 | 4279 | 9485 | 25130 |
| 1048576 | 1048576 | 3 | 98096 | 3005796.00 | 22954464 | 32635.61 | 7636733.83 | 2886 | 3534 | 4094 | 6593 | 22621 |
| 1048576 | 1048576 | avg | 92309.66 | 3041349.33 | 21600462.00 | 30389.68 | 7111185.82 | 3175.00 | 4024.33 | 4584.00 | 7671.33 | 21272.00 |
| 2097152 | 2097152 | 1 | 100754 | 3103216.00 | 23576436 | 32467.61 | 7597420.22 | 2866 | 3649 | 4302 | 10676 | 26977 |
| 2097152 | 2097152 | 2 | 96245 | 3081227.00 | 22521330 | 31235.93 | 7309208.31 | 2905 | 3519 | 4339 | 48484 | 88464 |
| 2097152 | 2097152 | 3 | 98777 | 3006892.00 | 23113818 | 32850.20 | 7686946.52 | 2896 | 3408 | 3952 | 7477 | 18650 |
| 2097152 | 2097152 | avg | 98592.00 | 3063778.33 | 23070528.00 | 32184.58 | 7531191.68 | 2889.00 | 3525.33 | 4197.66 | 22212.33 | 44697.00 |
| 4194304 | 4194304 | 1 | 98055 | 3008079.00 | 22944870 | 32597.22 | 7627748.47 | 2907 | 3638 | 4193 | 7761 | 22853 |
| 4194304 | 4194304 | 2 | 94780 | 3011138.00 | 22178520 | 31476.47 | 7365494.37 | 2893 | 3651 | 4531 | 24626 | 56064 |
| 4194304 | 4194304 | 3 | 98240 | 3007697.00 | 22988160 | 32662.86 | 7643110.33 | 2860 | 3537 | 4169 | 8609 | 30260 |
| 4194304 | 4194304 | avg | 97025.00 | 3008971.33 | 22703850.00 | 32245.51 | 7545451.05 | 2886.66 | 3608.66 | 4297.66 | 13665.33 | 36392.33 |
| 8388608 | 8388608 | 1 | 89287 | 3001730.00 | 20893158 | 29745.18 | 6960372.19 | 3479 | 4265 | 4694 | 7094 | 17501 |
| 8388608 | 8388608 | 2 | 94920 | 3007382.00 | 22211280 | 31562.34 | 7385586.53 | 2876 | 3475 | 4327 | 30951 | 64080 |
| 8388608 | 8388608 | 3 | 100685 | 3103437.00 | 23560408 | 32443.06 | 7591714.61 | 2929 | 3537 | 4064 | 6759 | 14720 |
| 8388608 | 8388608 | avg | 94964.00 | 3037516.33 | 22221615.33 | 31250.19 | 7312557.77 | 3094.66 | 3759.00 | 4361.66 | 14934.66 | 32100.33 |
| 16777216 | 16777216 | 1 | 96537 | 3019730.00 | 22589658 | 31968.75 | 7480688.01 | 2940 | 3647 | 4318 | 22677 | 65758 |
| 16777216 | 16777216 | 2 | 96221 | 3016581.00 | 22515714 | 31897.37 | 7463984.56 | 2922 | 3610 | 4273 | 10047 | 28482 |
| 16777216 | 16777216 | 3 | 98210 | 3006311.00 | 22981140 | 32667.94 | 7644298.94 | 2855 | 3549 | 4168 | 7835 | 17141 |
| 16777216 | 16777216 | avg | 96989.33 | 3014207.33 | 22695504.00 | 32178.02 | 7529657.17 | 2905.66 | 3602.00 | 4253.00 | 13519.66 | 37127.00 |
```

| rmem_max | wmem_max | run | requests | duration_in_microseconds | bytes | requests_per_sec | bytes_transfer_per_sec | 50% latency | 75% latency | 90% latency | 99% latency | 99.999% latency |
|----------|----------|-----|----------|-------------------------|-------|-----------------|-----------------------|-------------|-------------|-------------|-------------|-----------------|
| 262144 | 262144 | 1 | 66807 | 3002113.00 | 15632838 | 22253.33 | 5207278.34 | 3606 | 6393 | 6782 | 8246 | 19640 |
| 262144 | 262144 | 2 | 96522 | 3019552.00 | 22586148 | 31965.67 | 7479966.56 | 2934 | 3595 | 4220 | 8599 | 23334 |
| 262144 | 262144 | 3 | 97842 | 3013541.00 | 22895028 | 32467.45 | 7597383.94 | 3009 | 3553 | 4057 | 7864 | 23188 |
| 262144 | 262144 | avg | 87057.00 | 3011735.33 | 20371338.00 | 28895.48 | 6761542.94 | 3183.00 | 4513.66 | 5019.66 | 8236.33 | 22054.00 |
| 524288 | 524288 | 1 | 90517 | 3017210.00 | 21181096 | 30000.23 | 7020093.40 | 3102 | 3857 | 5119 | 134377 | 170768 |
| 524288 | 524288 | 2 | 95212 | 3002489.00 | 22279608 | 31711.02 | 7420379.56 | 2992 | 3696 | 4328 | 8806 | 21090 |
| 524288 | 524288 | 3 | 97703 | 3007289.00 | 22862502 | 32488.73 | 7602362.79 | 2967 | 3563 | 4074 | 7142 | 15402 |
| 524288 | 524288 | avg | 94477.33 | 3008996.00 | 22107735.33 | 31399.99 | 7347611.91 | 3020.33 | 3705.33 | 4507.00 | 50108.33 | 69086.66 |
| 1048576 | 1048576 | 1 | 82230 | 3100660.00 | 19241820 | 26520.16 | 6205717.49 | 3707 | 4896 | 5379 | 6936 | 16065 |
| 1048576 | 1048576 | 2 | 96603 | 3017592.00 | 22605102 | 32013.27 | 7491106.15 | 2932 | 3643 | 4279 | 9485 | 25130 |
| 1048576 | 1048576 | 3 | 98096 | 3005796.00 | 22954464 | 32635.61 | 7636733.83 | 2886 | 3534 | 4094 | 6593 | 22621 |
| 1048576 | 1048576 | avg | 92309.66 | 3041349.33 | 21600462.00 | 30389.68 | 7111185.82 | 3175.00 | 4024.33 | 4584.00 | 7671.33 | 21272.00 |
| 2097152 | 2097152 | 1 | 100754 | 3103216.00 | 23576436 | 32467.61 | 7597420.22 | 2866 | 3649 | 4302 | 10676 | 26977 |
| 2097152 | 2097152 | 2 | 96245 | 3081227.00 | 22521330 | 31235.93 | 7309208.31 | 2905 | 3519 | 4339 | 48484 | 88464 |
| 2097152 | 2097152 | 3 | 98777 | 3006892.00 | 23113818 | 32850.20 | 7686946.52 | 2896 | 3408 | 3952 | 7477 | 18650 |
| 2097152 | 2097152 | avg | 98592.00 | 3063778.33 | 23070528.00 | 32184.58 | 7531191.68 | 2889.00 | 3525.33 | 4197.66 | 22212.33 | 44697.00 |
| 4194304 | 4194304 | 1 | 98055 | 3008079.00 | 22944870 | 32597.22 | 7627748.47 | 2907 | 3638 | 4193 | 7761 | 22853 |
| 4194304 | 4194304 | 2 | 94780 | 3011138.00 | 22178520 | 31476.47 | 7365494.37 | 2893 | 3651 | 4531 | 24626 | 56064 |
| 4194304 | 4194304 | 3 | 98240 | 3007697.00 | 22988160 | 32662.86 | 7643110.33 | 2860 | 3537 | 4169 | 8609 | 30260 |
| 4194304 | 4194304 | avg | 97025.00 | 3008971.33 | 22703850.00 | 32245.51 | 7545451.05 | 2886.66 | 3608.66 | 4297.66 | 13665.33 | 36392.33 |
| 8388608 | 8388608 | 1 | 89287 | 3001730.00 | 20893158 | 29745.18 | 6960372.19 | 3479 | 4265 | 4694 | 7094 | 17501 |
| 8388608 | 8388608 | 2 | 94920 | 3007382.00 | 22211280 | 31562.34 | 7385586.53 | 2876 | 3475 | 4327 | 30951 | 64080 |
| 8388608 | 8388608 | 3 | 100685 | 3103437.00 | 23560408 | 32443.06 | 7591714.61 | 2929 | 3537 | 4064 | 6759 | 14720 |
| 8388608 | 8388608 | avg | 94964.00 | 3037516.33 | 22221615.33 | 31250.19 | 7312557.77 | 3094.66 | 3759.00 | 4361.66 | 14934.66 | 32100.33 |
| 16777216 | 16777216 | 1 | 96537 | 3019730.00 | 22589658 | 31968.75 | 7480688.01 | 2940 | 3647 | 4318 | 22677 | 65758 |
| 16777216 | 16777216 | 2 | 96221 | 3016581.00 | 22515714 | 31897.37 | 7463984.56 | 2922 | 3610 | 4273 | 10047 | 28482 |
| 16777216 | 16777216 | 3 | 98210 | 3006311.00 | 22981140 | 32667.94 | 7644298.94 | 2855 | 3549 | 4168 | 7835 | 17141 |
| 16777216 | 16777216 | avg | 96989.33 | 3014207.33 | 22695504.00 | 32178.02 | 7529657.17 | 2905.66 | 3602.00 | 4253.00 | 13519.66 | 37127.00 |

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