#!/bin/bash
# -------------------------------------------------------------------------------------------
TIME=10
PAUSE=1
PACKET=8K
DIR="./iperf-parallel/"
OUT="./iperf-parallel.csv"
# ------------------------------------------------------------------------------------------
if [[ -z $1 ]];
then
    echo "Missing mandatory argument: iperf3-server hostname or IP address "
    exit 1
fi
# --------------------------------------------------------------------------------------------
iperf3 -c $1 -t 2 > /dev/null 2>&1
if [ $? -ne 0 ]; then
   echo "Iperf returned an error. Check if iperf-server is runnung and reachable!"
   exit 1
fi
# -------------------------------------------------------------------------------------------
if [ -f "$OUT" ]; then
   rm -f $OUT
fi
# -------------------------------------------------------------------------------------------
if [ ! -d "$DIR" ]; then
  mkdir $DIR
fi
# --------------------------------------------------------------------------------------------
echo START
echo "Date;"$(date) >> $OUT
echo "Version;"$(iperf3 --version | grep iperf) >> $OUT
echo "Client;"$(hostname) >> $OUT
echo "Server;"$1 >> $OUT
echo "Each test duration;"$TIME >> $OUT
echo "Send size;"$PACKET >> $OUT
echo "" >> $OUT
echo $(ip link show eth0 | grep mtu  | awk -F" " '{ print $4 " = " $5 }'), TCP >> $OUT
echo "Parallel streams;Bandwidth, Gbits/sec;Retransmitted Segments, %;-;Transfer, GBytes;CPU Util local, %;CPU Util remote, %" >> $OUT
# ------------------------------------------------------------------------------------------------
p=1
TEST="TCP-P$p"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -t $TIME -P $p -i 0 -f g -l $PACKET --logfile $FILE > /dev/null 2>&1
echo $p";"$(awk -F"]" '/sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }')$(awk -F" " '/CPU/ { print $4 ";" $7 }' $FILE) >> $OUT
sleep $PAUSE
# ------------------------------------------------------------------------------------------------
for ((p=2; p<=16; p++))
do
TEST="TCP-P$p"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -t $TIME -P $p -i 0 -f g -l $PACKET --logfile $FILE > /dev/null 2>&1
echo $p";"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }')$(awk -F" " '/CPU/ { print $4 ";" $7 }' $FILE) >> $OUT
sleep $PAUSE
done
# --------------------------------------------------------------------------------------------------
