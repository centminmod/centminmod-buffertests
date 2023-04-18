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

```
cat buffertest-rmem_max-16777216-wmem_max-16777216.log
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
cat buffertest-rmem_max-16777216-wmem_max-16777216.json 
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
```
cat ss_output-rmem_max-16777216-wmem_max-16777216.log | jq -c '.[]' | tail -4 | jq -r

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