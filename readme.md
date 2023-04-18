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
testlogs/buffertest-rmem_max-262144-wmem_max-262144-4.json
testlogs/buffertest-rmem_max-262144-wmem_max-262144-5.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288-1.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288-2.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288-3.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288-4.json
testlogs/buffertest-rmem_max-524288-wmem_max-524288-5.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576-1.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576-2.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576-3.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576-4.json
testlogs/buffertest-rmem_max-1048576-wmem_max-1048576-5.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152-1.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152-2.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152-3.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152-4.json
testlogs/buffertest-rmem_max-2097152-wmem_max-2097152-5.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304-1.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304-2.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304-3.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304-4.json
testlogs/buffertest-rmem_max-4194304-wmem_max-4194304-5.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608-1.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608-2.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608-3.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608-4.json
testlogs/buffertest-rmem_max-8388608-wmem_max-8388608-5.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-1.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-2.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-3.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-4.json
testlogs/buffertest-rmem_max-16777216-wmem_max-16777216-5.json
```

The `generate-table.sh` script will aggregrate all the work JSON log files into a markdown format table:

```
./generate-table.sh 

| rmem_max | wmem_max | run | requests | duration_in_microseconds | bytes | requests_per_sec | bytes_transfer_per_sec | 50% latency | 75% latency | 90% latency | 99% latency | 99.999% latency |
|----------|----------|-----|----------|-------------------------|-------|-----------------|-----------------------|-------------|-------------|-------------|-------------|-----------------|
| 262144 | 262144 | 1 | 63551 | 3001455.00 | 14870934 | 21173.40 | 4954575.03 | 4672 | 4913 | 5312 | 6773 | 16789 |
| 262144 | 262144 | 2 | 97047 | 3105272.00 | 22708998 | 31252.33 | 7313046.33 | 3136 | 3877 | 4446 | 10389 | 39666 |
| 262144 | 262144 | 3 | 97954 | 3019051.00 | 22921236 | 32445.29 | 7592199.01 | 2965 | 3559 | 4085 | 7209 | 15906 |
| 262144 | 262144 | 4 | 93625 | 3029567.00 | 21908250 | 30903.76 | 7231478.95 | 3092 | 3848 | 4525 | 27004 | 58266 |
| 262144 | 262144 | 5 | 96732 | 3016724.00 | 22635288 | 32065.25 | 7503267.78 | 2989 | 3705 | 4256 | 8075 | 24242 |
| 262144 | 262144 | avg | 89781.80 | 3034413.80 | 21008941.20 | 29568.00 | 6918913.42 | 3370.80 | 3980.40 | 4524.80 | 11890.00 | 30973.80 |
| 524288 | 524288 | 1 | 84337 | 3003476.00 | 19734858 | 28079.80 | 6570672.78 | 3531 | 3781 | 4023 | 5842 | 16058 |
| 524288 | 524288 | 2 | 89113 | 3023020.00 | 20852442 | 29478.14 | 6897884.23 | 3085 | 3823 | 5699 | 181706 | 227811 |
| 524288 | 524288 | 3 | 97743 | 3005705.00 | 22871862 | 32519.16 | 7609483.30 | 2970 | 3547 | 4040 | 6362 | 14061 |
| 524288 | 524288 | 4 | 94375 | 3028438.00 | 22083750 | 31162.93 | 7292125.51 | 2948 | 3757 | 4551 | 13155 | 29096 |
| 524288 | 524288 | 5 | 93776 | 3078464.00 | 21943584 | 30461.94 | 7128095.05 | 2988 | 3780 | 4755 | 80573 | 117008 |
| 524288 | 524288 | avg | 91868.80 | 3027820.60 | 21497299.20 | 30340.39 | 7099652.17 | 3104.40 | 3737.60 | 4613.60 | 57527.60 | 80806.80 |
| 1048576 | 1048576 | 1 | 97735 | 3009918.00 | 22869990 | 32470.98 | 7598210.32 | 2922 | 3664 | 4267 | 9120 | 22512 |
| 1048576 | 1048576 | 2 | 94869 | 3071638.00 | 22199346 | 30885.48 | 7227201.25 | 2975 | 3730 | 4713 | 51239 | 91018 |
| 1048576 | 1048576 | 3 | 97460 | 3003363.00 | 22805640 | 32450.29 | 7593367.83 | 2979 | 3554 | 4071 | 7125 | 20104 |
| 1048576 | 1048576 | 4 | 94827 | 3004829.00 | 22189518 | 31558.20 | 7384619.22 | 3003 | 3724 | 4370 | 10651 | 24080 |
| 1048576 | 1048576 | 5 | 97318 | 3105414.00 | 22772412 | 31338.17 | 7333132.39 | 3027 | 3806 | 4470 | 10827 | 29620 |
| 1048576 | 1048576 | avg | 96441.80 | 3039032.40 | 22567381.20 | 31740.62 | 7427306.20 | 2981.20 | 3695.60 | 4378.20 | 17792.40 | 37466.80 |
| 2097152 | 2097152 | 1 | 97434 | 3009488.00 | 22799556 | 32375.61 | 7575891.98 | 2936 | 3693 | 4314 | 8317 | 24905 |
| 2097152 | 2097152 | 2 | 85072 | 3021270.00 | 19906848 | 28157.70 | 6588900.69 | 3085 | 3936 | 13005 | 314501 | 354925 |
| 2097152 | 2097152 | 3 | 97964 | 3004481.00 | 22923576 | 32605.96 | 7629795.63 | 2957 | 3553 | 4049 | 6240 | 18521 |
| 2097152 | 2097152 | 4 | 87844 | 3036337.00 | 20555496 | 28930.91 | 6769833.52 | 3124 | 3949 | 7115 | 171223 | 278625 |
| 2097152 | 2097152 | 5 | 93785 | 3060001.00 | 21945690 | 30648.68 | 7171791.77 | 3061 | 3796 | 4498 | 55082 | 98872 |
| 2097152 | 2097152 | avg | 92419.80 | 3026315.40 | 21626233.20 | 30543.77 | 7147242.71 | 3032.60 | 3785.40 | 6596.20 | 111072.60 | 155169.60 |
| 4194304 | 4194304 | 1 | 96777 | 3012000.00 | 22645818 | 32130.48 | 7518531.87 | 2966 | 3788 | 4394 | 10997 | 22967 |
| 4194304 | 4194304 | 2 | 95136 | 3015311.00 | 22261824 | 31550.97 | 7382928.00 | 3018 | 3705 | 4365 | 10241 | 18304 |
| 4194304 | 4194304 | 3 | 98410 | 3008056.00 | 23027940 | 32715.48 | 7655422.64 | 2835 | 3520 | 4138 | 7120 | 15593 |
| 4194304 | 4194304 | 4 | 96254 | 3030577.00 | 22523436 | 31760.95 | 7432061.95 | 2931 | 3564 | 4210 | 9512 | 27812 |
| 4194304 | 4194304 | 5 | 88479 | 3075820.00 | 20704086 | 28765.99 | 6731241.10 | 3062 | 3894 | 7362 | 177823 | 230648 |
| 4194304 | 4194304 | avg | 95011.20 | 3028352.80 | 22232620.80 | 31384.77 | 7344037.11 | 2962.40 | 3694.20 | 4893.80 | 43138.60 | 63064.80 |
| 8388608 | 8388608 | 1 | 97575 | 3014280.00 | 22832550 | 32370.91 | 7574793.98 | 2924 | 3619 | 4225 | 8483 | 32516 |
| 8388608 | 8388608 | 2 | 92516 | 3003261.00 | 21648744 | 30805.18 | 7208412.46 | 2940 | 3710 | 4774 | 71850 | 106363 |
| 8388608 | 8388608 | 3 | 98459 | 3006215.00 | 23039406 | 32751.82 | 7663924.90 | 2876 | 3530 | 4092 | 9722 | 33934 |
| 8388608 | 8388608 | 4 | 94882 | 3012008.00 | 22202506 | 31501.24 | 7371330.36 | 3044 | 3678 | 4294 | 9496 | 19624 |
| 8388608 | 8388608 | 5 | 93832 | 3076735.00 | 21956688 | 30497.26 | 7136359.81 | 3060 | 3864 | 4685 | 60110 | 92268 |
| 8388608 | 8388608 | avg | 95452.80 | 3022499.80 | 22335978.80 | 31585.28 | 7390964.30 | 2968.80 | 3680.20 | 4414.00 | 31932.20 | 56941.00 |
| 16777216 | 16777216 | 1 | 97750 | 3001686.00 | 22873500 | 32565.03 | 7620217.44 | 2811 | 3656 | 4361 | 13995 | 60075 |
| 16777216 | 16777216 | 2 | 98452 | 3103751.00 | 23037768 | 31720.33 | 7422556.77 | 2819 | 3602 | 4396 | 19046 | 54174 |
| 16777216 | 16777216 | 3 | 98467 | 3009658.00 | 23041278 | 32717.01 | 7655779.49 | 2825 | 3536 | 4160 | 8057 | 22243 |
| 16777216 | 16777216 | 4 | 89319 | 3042886.00 | 20900646 | 29353.38 | 6868691.76 | 3069 | 3806 | 5150 | 179597 | 221400 |
| 16777216 | 16777216 | 5 | 94874 | 3005368.00 | 22200516 | 31568.18 | 7386954.28 | 3031 | 3761 | 4356 | 9287 | 24257 |
| 16777216 | 16777216 | avg | 95772.40 | 3032669.80 | 22410741.60 | 31584.78 | 7390839.94 | 2911.00 | 3672.20 | 4484.60 | 45996.40 | 76429.80 |
```

| rmem_max | wmem_max | run | requests | duration_in_microseconds | bytes | requests_per_sec | bytes_transfer_per_sec | 50% latency | 75% latency | 90% latency | 99% latency | 99.999% latency |
|----------|----------|-----|----------|-------------------------|-------|-----------------|-----------------------|-------------|-------------|-------------|-------------|-----------------|
| 262144 | 262144 | 1 | 63551 | 3001455.00 | 14870934 | 21173.40 | 4954575.03 | 4672 | 4913 | 5312 | 6773 | 16789 |
| 262144 | 262144 | 2 | 97047 | 3105272.00 | 22708998 | 31252.33 | 7313046.33 | 3136 | 3877 | 4446 | 10389 | 39666 |
| 262144 | 262144 | 3 | 97954 | 3019051.00 | 22921236 | 32445.29 | 7592199.01 | 2965 | 3559 | 4085 | 7209 | 15906 |
| 262144 | 262144 | 4 | 93625 | 3029567.00 | 21908250 | 30903.76 | 7231478.95 | 3092 | 3848 | 4525 | 27004 | 58266 |
| 262144 | 262144 | 5 | 96732 | 3016724.00 | 22635288 | 32065.25 | 7503267.78 | 2989 | 3705 | 4256 | 8075 | 24242 |
| 262144 | 262144 | avg | 89781.80 | 3034413.80 | 21008941.20 | 29568.00 | 6918913.42 | 3370.80 | 3980.40 | 4524.80 | 11890.00 | 30973.80 |
| 524288 | 524288 | 1 | 84337 | 3003476.00 | 19734858 | 28079.80 | 6570672.78 | 3531 | 3781 | 4023 | 5842 | 16058 |
| 524288 | 524288 | 2 | 89113 | 3023020.00 | 20852442 | 29478.14 | 6897884.23 | 3085 | 3823 | 5699 | 181706 | 227811 |
| 524288 | 524288 | 3 | 97743 | 3005705.00 | 22871862 | 32519.16 | 7609483.30 | 2970 | 3547 | 4040 | 6362 | 14061 |
| 524288 | 524288 | 4 | 94375 | 3028438.00 | 22083750 | 31162.93 | 7292125.51 | 2948 | 3757 | 4551 | 13155 | 29096 |
| 524288 | 524288 | 5 | 93776 | 3078464.00 | 21943584 | 30461.94 | 7128095.05 | 2988 | 3780 | 4755 | 80573 | 117008 |
| 524288 | 524288 | avg | 91868.80 | 3027820.60 | 21497299.20 | 30340.39 | 7099652.17 | 3104.40 | 3737.60 | 4613.60 | 57527.60 | 80806.80 |
| 1048576 | 1048576 | 1 | 97735 | 3009918.00 | 22869990 | 32470.98 | 7598210.32 | 2922 | 3664 | 4267 | 9120 | 22512 |
| 1048576 | 1048576 | 2 | 94869 | 3071638.00 | 22199346 | 30885.48 | 7227201.25 | 2975 | 3730 | 4713 | 51239 | 91018 |
| 1048576 | 1048576 | 3 | 97460 | 3003363.00 | 22805640 | 32450.29 | 7593367.83 | 2979 | 3554 | 4071 | 7125 | 20104 |
| 1048576 | 1048576 | 4 | 94827 | 3004829.00 | 22189518 | 31558.20 | 7384619.22 | 3003 | 3724 | 4370 | 10651 | 24080 |
| 1048576 | 1048576 | 5 | 97318 | 3105414.00 | 22772412 | 31338.17 | 7333132.39 | 3027 | 3806 | 4470 | 10827 | 29620 |
| 1048576 | 1048576 | avg | 96441.80 | 3039032.40 | 22567381.20 | 31740.62 | 7427306.20 | 2981.20 | 3695.60 | 4378.20 | 17792.40 | 37466.80 |
| 2097152 | 2097152 | 1 | 97434 | 3009488.00 | 22799556 | 32375.61 | 7575891.98 | 2936 | 3693 | 4314 | 8317 | 24905 |
| 2097152 | 2097152 | 2 | 85072 | 3021270.00 | 19906848 | 28157.70 | 6588900.69 | 3085 | 3936 | 13005 | 314501 | 354925 |
| 2097152 | 2097152 | 3 | 97964 | 3004481.00 | 22923576 | 32605.96 | 7629795.63 | 2957 | 3553 | 4049 | 6240 | 18521 |
| 2097152 | 2097152 | 4 | 87844 | 3036337.00 | 20555496 | 28930.91 | 6769833.52 | 3124 | 3949 | 7115 | 171223 | 278625 |
| 2097152 | 2097152 | 5 | 93785 | 3060001.00 | 21945690 | 30648.68 | 7171791.77 | 3061 | 3796 | 4498 | 55082 | 98872 |
| 2097152 | 2097152 | avg | 92419.80 | 3026315.40 | 21626233.20 | 30543.77 | 7147242.71 | 3032.60 | 3785.40 | 6596.20 | 111072.60 | 155169.60 |
| 4194304 | 4194304 | 1 | 96777 | 3012000.00 | 22645818 | 32130.48 | 7518531.87 | 2966 | 3788 | 4394 | 10997 | 22967 |
| 4194304 | 4194304 | 2 | 95136 | 3015311.00 | 22261824 | 31550.97 | 7382928.00 | 3018 | 3705 | 4365 | 10241 | 18304 |
| 4194304 | 4194304 | 3 | 98410 | 3008056.00 | 23027940 | 32715.48 | 7655422.64 | 2835 | 3520 | 4138 | 7120 | 15593 |
| 4194304 | 4194304 | 4 | 96254 | 3030577.00 | 22523436 | 31760.95 | 7432061.95 | 2931 | 3564 | 4210 | 9512 | 27812 |
| 4194304 | 4194304 | 5 | 88479 | 3075820.00 | 20704086 | 28765.99 | 6731241.10 | 3062 | 3894 | 7362 | 177823 | 230648 |
| 4194304 | 4194304 | avg | 95011.20 | 3028352.80 | 22232620.80 | 31384.77 | 7344037.11 | 2962.40 | 3694.20 | 4893.80 | 43138.60 | 63064.80 |
| 8388608 | 8388608 | 1 | 97575 | 3014280.00 | 22832550 | 32370.91 | 7574793.98 | 2924 | 3619 | 4225 | 8483 | 32516 |
| 8388608 | 8388608 | 2 | 92516 | 3003261.00 | 21648744 | 30805.18 | 7208412.46 | 2940 | 3710 | 4774 | 71850 | 106363 |
| 8388608 | 8388608 | 3 | 98459 | 3006215.00 | 23039406 | 32751.82 | 7663924.90 | 2876 | 3530 | 4092 | 9722 | 33934 |
| 8388608 | 8388608 | 4 | 94882 | 3012008.00 | 22202506 | 31501.24 | 7371330.36 | 3044 | 3678 | 4294 | 9496 | 19624 |
| 8388608 | 8388608 | 5 | 93832 | 3076735.00 | 21956688 | 30497.26 | 7136359.81 | 3060 | 3864 | 4685 | 60110 | 92268 |
| 8388608 | 8388608 | avg | 95452.80 | 3022499.80 | 22335978.80 | 31585.28 | 7390964.30 | 2968.80 | 3680.20 | 4414.00 | 31932.20 | 56941.00 |
| 16777216 | 16777216 | 1 | 97750 | 3001686.00 | 22873500 | 32565.03 | 7620217.44 | 2811 | 3656 | 4361 | 13995 | 60075 |
| 16777216 | 16777216 | 2 | 98452 | 3103751.00 | 23037768 | 31720.33 | 7422556.77 | 2819 | 3602 | 4396 | 19046 | 54174 |
| 16777216 | 16777216 | 3 | 98467 | 3009658.00 | 23041278 | 32717.01 | 7655779.49 | 2825 | 3536 | 4160 | 8057 | 22243 |
| 16777216 | 16777216 | 4 | 89319 | 3042886.00 | 20900646 | 29353.38 | 6868691.76 | 3069 | 3806 | 5150 | 179597 | 221400 |
| 16777216 | 16777216 | 5 | 94874 | 3005368.00 | 22200516 | 31568.18 | 7386954.28 | 3031 | 3761 | 4356 | 9287 | 24257 |
| 16777216 | 16777216 | avg | 95772.40 | 3032669.80 | 22410741.60 | 31584.78 | 7390839.94 | 2911.00 | 3672.20 | 4484.60 | 45996.40 | 76429.80 |

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