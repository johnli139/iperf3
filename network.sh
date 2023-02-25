#!/bin/bash
# -------------------------------------------------------------------------------------------
if [[ -z $1 ]];
then
    echo "Missing mandatory argument: iperf3-server hostname or IP address "
    exit 1
fi
# --------------------------------------------------------------------------------------------
iperf3 -c $1 -t 2 > /dev/null
if [ $? -ne 0 ]; then
   echo "Iperf returned an error. Check if iperf-server is runnung and reachable!"
   exit 1
fi
# --------------------------------------------------------------------------------------------
OUT="./iperf-basic.csv"
if [ -f "$OUT" ]; then
   rm -f $OUT
fi
DIR="./iperf-basic/"
if [ ! -d "$DIR" ]; then
  mkdir $DIR
fi
# -------------------------------------------------------------------------------------------
echo "Date: " $(date) >> $OUT
echo "Version: " $(iperf3 --version | grep iperf) >> $OUT
echo "Client: " $(hostname) >> $OUT
echo "Server: " $1 >> $OUT
echo "" >> $OUT
# -------------------------------------------------------------------------------------------
ip link set mtu 1500 dev eth0
source ibasic.sh $1
ip link set mtu 8800 dev eth0
source ibasic.sh $1
