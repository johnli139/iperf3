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
OUT="./iperf-basic-$(ip link show eth0 | grep mtu  | awk -F" " '{ print $5 }').csv"
if [ -f "$OUT" ]; then
   rm -f $OUT
fi
DIR="./iperf-basic/"
if [ ! -d "$DIR" ]; then
  mkdir $DIR
fi
TIME=10
PAUSE=1
# --------------------------------------------------------------------------------------------
echo "Date: " $(date) >> $OUT
echo "Version: " $(iperf3 --version | grep iperf) >> $OUT
echo "Client: " $(hostname) >> $OUT
echo "Server: " $1 >> $OUT
echo "" >> $OUT
echo $(ip link show eth0 | grep mtu  | awk -F" " '{ print $4 " = " $5 }'), TCP >> $OUT
echo "Test name;Send size;Parallel streams;Bandwidth, Gbits/sec;Retransmitted Segments, %;-;Transfer, GBytes" >> $OUT
#
#
#
# --------------------------------------------------------------------------------------------
TEST="TCP-512-1"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 1 -f g -l 512 --logfile $FILE > /dev/null 2>&1
echo $TEST";512"";1;"$(awk -F"]" '/sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-512-2"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 2 -f g -l 512 --logfile $FILE > /dev/null 2>&1
echo $TEST";512"";2;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-512-3"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 3 -f g -l 512 --logfile $FILE > /dev/null 2>&1
echo $TEST";512"";3;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-512-4"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 4 -f g -l 512 --logfile $FILE > /dev/null 2>&1
echo $TEST";512"";4;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-1448-1"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 1 -f g -l 1448 --logfile $FILE > /dev/null 2>&1
echo $TEST";1448"";1;"$(awk -F"]" '/sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-1448-2"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 2 -f g -l 1448 --logfile $FILE > /dev/null 2>&1
echo $TEST";1448"";2;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-1448-3"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 3 -f g -l 1448 --logfile $FILE > /dev/null 2>&1
echo $TEST";1448"";3;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-1448-4"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 4 -f g -l 1448 --logfile $FILE > /dev/null 2>&1
echo $TEST";1448"";4;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-8K-1"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 1 -f g -l 8192 --logfile $FILE > /dev/null 2>&1
echo $TEST";8192"";1;"$(awk -F"]" '/sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-8K-2"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 2 -f g -l 8192 --logfile $FILE > /dev/null 2>&1
echo $TEST";8192"";2;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-8K-3"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 3 -f g -l 8192 --logfile $FILE > /dev/null 2>&1
echo $TEST";8192"";3;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-8K-4"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 4 -f g -l 8192 --logfile $FILE > /dev/null 2>&1
echo $TEST";8192"";4;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-64K-1"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 1 -f g -l 65500 --logfile $FILE > /dev/null 2>&1
echo $TEST";65500"";1;"$(awk -F"]" '/sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-64K-2"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 2 -f g -l 65500 --logfile $FILE > /dev/null 2>&1
echo $TEST";65500"";2;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-64K-3"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 3 -f g -l 65500 --logfile $FILE > /dev/null 2>&1
echo $TEST";65500"";3;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
TEST="TCP-64K-4"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -V -4 -t $TIME -O 1 -P 4 -f g -l 65500 --logfile $FILE > /dev/null 2>&1
echo $TEST";65500"";4;"$(awk -F"]" '/SUM.*sender$/ { print $2 }' $FILE | awk -F" " '{ print $5 ";=" $7 "/(" $3 "*1024*1024*1024/131072);;" $3 ";" }') >> $OUT
sleep $PAUSE
# ---------------------------------------------------------------------------------------------
#
#
#
#
# ---------------------------------------------------------------------------------------------
echo "" >> $OUT
echo $(ip link show eth0 | grep mtu  | awk -F" " '{ print $4 " = " $5 }'), UDP >> $OUT
echo "Test name;Send size;Parallel streams;Bandwidth, Gbits/sec;Lost Datagrams, %;Jitter, ms;Transfer, GBytes" >> $OUT
# ----------------------------------------------------------------------------------------------
TEST="UDP-512-1"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 1 -f g -l 512 --logfile $FILE > /dev/null 2>&1
echo $TEST";512;1;"$(awk -F"]" '/ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-512-2"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 2 -f g -l 512 --logfile $FILE > /dev/null 2>&1
echo $TEST";512;2;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-512-3"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 3 -f g -l 512 --logfile $FILE > /dev/null 2>&1
echo $TEST";512;3;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-512-4"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 4 -f g -l 512 --logfile $FILE > /dev/null 2>&1
echo $TEST";512;4;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-1448-1"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 1 -f g -l 1448 --logfile $FILE > /dev/null 2>&1
echo $TEST";1448;1;"$(awk -F"]" '/ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-1448-2"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 2 -f g -l 1448 --logfile $FILE > /dev/null 2>&1
echo $TEST";1448;2;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-1448-3"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 3 -f g -l 1448 --logfile $FILE > /dev/null 2>&1
echo $TEST";1448;3;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------
TEST="UDP-1448-4"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 4 -f g -l 1448 --logfile $FILE > /dev/null 2>&1
echo $TEST";1448;4;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-8K-1"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 1 -f g -l 8192 --logfile $FILE > /dev/null 2>&1
echo $TEST";8192;1;"$(awk -F"]" '/ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-8K-2"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 2 -f g -l 8192 --logfile $FILE > /dev/null 2>&1
echo $TEST";8192;2;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-8K-3"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 3 -f g -l 8192 --logfile $FILE > /dev/null 2>&1
echo $TEST";8192;3;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------
TEST="UDP-8K-4"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 4 -f g -l 8192 --logfile $FILE > /dev/null 2>&1
echo $TEST";8192;4;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-64K-1"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 1 -f g -l 65500 --logfile $FILE > /dev/null 2>&1
echo $TEST";65500;1;"$(awk -F"]" '/ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-64K-2"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 2 -f g -l 65500 --logfile $FILE > /dev/null 2>&1
echo $TEST";65500;2;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
TEST="UDP-64K-3"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 3 -f g -l 65500 --logfile $FILE > /dev/null 2>&1
echo $TEST";65500;3;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------
TEST="UDP-64K-4"
echo Testing $TEST
FILE="$DIR$TEST.txt"
if [ -f "$FILE" ]; then
   rm -f $FILE
fi
iperf3 -c $1 -u -b 100G -V -4 -t $TIME -O 1 -P 4 -f g -l 65000 --logfile $FILE > /dev/null 2>&1
echo $TEST";65500;4;"$(awk -F"]" '/SUM.*ms / { print $2 }' $FILE | awk -F" " '{ print $5 ";" "="$9 ";" $7 ";" $3 ";" }') >> $OUT
sleep $PAUSE
# ----------------------------------------------------------------------------------------------
